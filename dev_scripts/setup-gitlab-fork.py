#!/usr/bin/env python3
import logging
import sys
import time
from pathlib import Path

import requests


logging.basicConfig(stream=sys.stderr, level=logging.INFO)
logger = logging.getLogger(__name__)


class GitLabForkHelper:
    GITLAB_API_URL = "https://gitlab.synerty.com/api/v4"
    OFFICIAL_GROUP_IDS = {
        "community": 74,
        "enterprise": 75,
        "util": 26,
    }

    def __init__(
        self,
        gitlabToken: str,
        forkedPeekCommunityGroupId: int,
        forkedPeekEnterpriseGroupId: int,
        forkedPeekUtilGroupId: int,
    ):
        self._gitlabToken = gitlabToken
        self._forkedPeekCommunityGroupId = forkedPeekCommunityGroupId
        self._forkedPeekEnterpriseGroupId = forkedPeekEnterpriseGroupId
        self._forkedPeekUtilGroupId = forkedPeekUtilGroupId
        self._session = requests.session()
        self._gitlab_api_headers = {
            "Authorization": f"Bearer {self._gitlabToken}"
        }
        self._forksInProgress = set({})

    def fork(self):

        for groupName, forkedGroupId in {
            "community": self._forkedPeekCommunityGroupId,
            "enterprise": self._forkedPeekEnterpriseGroupId,
            "util": self._forkedPeekUtilGroupId,
        }.items():
            # check projects need forking
            projectsToBeForked = self.diffGroups(
                self.OFFICIAL_GROUP_IDS[groupName],
                forkedGroupId,
            )

            # do forking
            for project in projectsToBeForked:
                self._printProject("Fork not found", project)
                self._printProject("Forking", project, showImportStatus=True)
                forkedProjectId = self._createFork(project, forkedGroupId)
                self._forksInProgress.add(forkedProjectId)

        # check forking progress
        while self._forksInProgress:
            logger.info("Checking forking progress")
            self._checkForkingProgress()
            time.sleep(1)

        logger.info("Your fork setup is up to date.")

    def _getProjectsInGroup(self, groupId: int, isOrigin: bool) -> set[int]:
        # GET /groups/:id/projects
        # https://docs.gitlab.com/12.10/ee/api/groups.html#list-a-groups-projects

        url = f"{self.GITLAB_API_URL}/groups/{groupId}/projects?per_page=999"
        r = self._session.get(
            url=url,
            headers=self._gitlab_api_headers,
        )
        projects = set({})
        for project in r.json():
            if isOrigin:
                if "id" in project.keys():
                    projects.add(project["id"])

            if not isOrigin:
                if "forked_from_project" in project.keys():
                    projects.add(project["forked_from_project"]["id"])

        return projects

    def _printProject(
        self, text: str, projectId: int, showImportStatus: bool = False
    ):
        url = f"{self.GITLAB_API_URL}/projects/{projectId}"
        r = self._session.get(url=url, headers=self._gitlab_api_headers)
        j = r.json()

        message = f"""{text} '{j["path_with_namespace"]}' ({j["web_url"]}) """
        if showImportStatus:
            logger.info(f"""{message} import_status: {j["import_status"]}""")
        else:
            logger.info(message)

    def _checkForkingProgress(self):
        for projectId in self._forksInProgress.copy():
            url = f"{self.GITLAB_API_URL}/projects/{projectId}"
            r = self._session.get(url=url, headers=self._gitlab_api_headers)
            # import status enum
            #     created
            #     started
            #     finished
            #     failed
            # https://docs.gitlab.com/ee/api/bulk_imports.html#list-all-gitlab-migrations
            importStatus = r.json().get("import_status", "failed")
            if importStatus == "finished":
                self._forksInProgress.remove(projectId)

        forkingCount = len(self._forksInProgress)

        if forkingCount:
            logger.info(f"{forkingCount} projects have not finished forking.")
            for projectId in self._forksInProgress:
                self._printProject(
                    "Current forking status", projectId, showImportStatus=True
                )
        else:
            logger.info("All new forkings have finished.")

    def _createFork(self, originProjectId: int, targetNamespaceId: int) -> int:
        url = f"{self.GITLAB_API_URL}/projects/{originProjectId}/fork"
        data = {"id": originProjectId, "namespace_id": targetNamespaceId}
        r = self._session.post(
            url=url, headers=self._gitlab_api_headers, data=data
        )
        # forked project id
        return r.json().get("id", None)

    def diffGroups(self, originGroupId: int, forkedGroupId: int) -> set[int]:
        forkedProjects = self._getProjectsInGroup(forkedGroupId, isOrigin=False)
        originalProjects = self._getProjectsInGroup(
            originGroupId, isOrigin=True
        )
        return originalProjects.difference(forkedProjects)


if __name__ == "__main__":
    import sys

    if len(sys.argv) != 5:
        logger.error("invalid arguments.")
        logger.error(
            "This forks Peek git repositories that are not forked under your "
            "username, to your fork groups."
            "\n"
            f"Usage: {Path(__file__).name} <gitlab token> "
            f"<forked peek community group id> "
            f"<forked peek enterprise group id> "
            f"<forked peek util group id>"
        )
        exit(1)

    gitlabToken = sys.argv[1]
    forkedPeekCommunityGroupId = int(sys.argv[2])
    forkedPeekEnterpriseGroupId = int(sys.argv[3])
    forkedPeekUtilGroupId = int(sys.argv[4])

    g = GitLabForkHelper(
        gitlabToken=gitlabToken,
        forkedPeekCommunityGroupId=forkedPeekCommunityGroupId,
        forkedPeekEnterpriseGroupId=forkedPeekEnterpriseGroupId,
        forkedPeekUtilGroupId=forkedPeekUtilGroupId,
    )

    g.fork()
