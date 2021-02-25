#!/usr/bin/env python3
import os
from collections import Set
from collections import namedtuple
from pathlib import Path
from pprint import pprint
from typing import Dict

import requests


with open("../.gitlabtoken", "r") as token_file:
    GITLAB_ACCESS_TOKEN = token_file.readline().strip()

assert GITLAB_ACCESS_TOKEN, "config your gitlab access token first"


PEEK_NAMESPACES = ["peek/community", "peek/enterprise"]

PEEK_OFFICIAL_GROUPS = {"community": 74, "enterprise": 75}

ALLOWED_ACCESS_LEVELS = {
    0: "No",
    30: "Developer",
    40: "Maintainer",
    60: "Admin",
}

# swap key and value
ALLOWED_ACCESS_LEVELS = dict(
    [(value, key) for key, value in ALLOWED_ACCESS_LEVELS.items()]
)

_namedRepoTuple = namedtuple("repo", ["id", "pathWithNamespace"])


def _buildGitlabUrl(repoPathWithNamespace):
    return f"https://gitlab.synerty.com/{repoPathWithNamespace}"


def _requestGitlab(url, method="get", data="") -> dict:
    headers = {
        "Authorization": f"Bearer {GITLAB_ACCESS_TOKEN}",
        "Content-Type": "application/json",
    }
    if method.lower() == "post":
        r = requests.post(url, data=data, headers=headers)
    else:
        r = requests.get(url, headers=headers)
    return r.json()


def _displayLoginUser():
    url = "https://gitlab.synerty.com/api/v4/user"
    userProfile = _requestGitlab(url)
    username = userProfile["name"]
    email = userProfile["email"]
    return f'"{username}<{email}>"'


def getRemoteOfficialRepos() -> Dict[str, _namedRepoTuple]:
    repos = {}
    for officialGroupName, officialGroupID in PEEK_OFFICIAL_GROUPS.items():
        url = (
            f"https://gitlab.synerty.com/api/v4/groups/"
            f"{officialGroupID}?with_projects=true"
        )
        json_ = _requestGitlab(url, method="get")
        officialRepos = json_["projects"]
        for officialRepo in officialRepos:
            key = officialRepo["path"]
            repo = _namedRepoTuple(
                id=officialRepo["id"],
                pathWithNamespace=officialRepo["path_with_namespace"],
            )
            repos[key] = repo
    return repos


def getRemoteForkedRepos() -> Dict[str, _namedRepoTuple]:
    repos = {}
    url = (
        "https://gitlab.synerty.com/api/v4/projects/?simple=false&owned"
        "=true&per_page=999"
    )
    remoteRepos = _requestGitlab(url, method="get")
    for remoteRepo in remoteRepos:
        namespace = remoteRepo["namespace"]["full_path"]
        # filter non-peek projects
        for subNamespace in PEEK_NAMESPACES:
            if namespace.endswith(subNamespace):
                repo = _namedRepoTuple(
                    id=remoteRepo["id"],
                    pathWithNamespace=remoteRepo["path_with_namespace"],
                )
                key = remoteRepo["path"]
                repos[key] = repo
    return repos


def getLocalRepoSet() -> Set[str]:
    repos = set([])
    for folder in (Path.home() / Path("dev-peek")).iterdir():
        key = folder.name
        # skip hidden folders e.g. .idea, .DS_Store
        if key.startswith("."):
            continue
        repos.add(key)
    return repos


def checkForkInSync(repoPathWithNamespace):
    username, _, repoPath = repoPathWithNamespace.partition("/")
    repoName = repoPath.split("/")[-1]
    cdCommand = f"cd /Users/peek/dev-peek/{repoName}"

    # add upstream
    os.system(
        f"{cdCommand} && git remote add upstream git@gitlab.synerty.com:{repoPath}.git"
    )
    # fetch upstream/master
    os.system(f"{cdCommand} && git fetch upstream master")

    # fetch origin/master
    os.system(f"{cdCommand} && git fetch origin master")

    # check if origin/master is in sync with upstream/master
    originInSync = False
    retCode = os.system(
        f"{cdCommand} && if [[ $(git diff origin/master upstream/master --stat) ]]; then exit 1; else exit 0; fi"
    )
    if retCode != 0:
        print(
            "!!!",
            repoName,
            _buildGitlabUrl(repoPathWithNamespace),
            "ORIGIN NOT IN SYNC",
        )
    else:
        print(
            "+++",
            repoName,
            _buildGitlabUrl(repoPathWithNamespace),
            "ORIGIN IN SYNC",
        )
        originInSync = True

    # check if origin/master is in sync with upstream/master
    localInSync = False
    retCode = os.system(
        f"{cdCommand} && if [[ $(git diff master origin/master --stat) ]]; then exit 1; else exit 0; fi"
    )
    if retCode != 0:
        print(
            "!!!",
            repoName,
            _buildGitlabUrl(repoPathWithNamespace),
            "LOCAL NOT IN SYNC",
        )
    else:
        print(
            "+++",
            repoName,
            _buildGitlabUrl(repoPathWithNamespace),
            "LOCAL IN SYNC",
        )
        localInSync = True

    # remote upstream
    os.system(f"{cdCommand} && git remote remove upstream")

    return originInSync, localInSync


def forcePushFromOfficialSourceToFork(repoId, repoNameWithNamespace):
    username, _, repoPath = repoNameWithNamespace.partition("/")
    repoName = repoPath.split("/")[-1]

    cloneRepoBasedir = "/Users/peek/dev-peek/__tmp/"
    Path(cloneRepoBasedir).mkdir(exist_ok=True)
    cdCommand = f"cd {cloneRepoBasedir}"

    print("+++", username, repoPath, repoName)

    # git clone
    os.system(f"{cdCommand} && git clone git@gitlab.synerty.com:{repoPath}.git")
    # unproected master branch in user's fork
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {GITLAB_ACCESS_TOKEN}",
    }
    r = requests.delete(
        f"https://gitlab.synerty.com/api/v4/projects/{repoId}/protected_branches/master",
        headers=headers,
    )
    print("unprotect status code: ", r.status_code)

    # git forced push to user's repo
    os.system(
        f"{cdCommand}/{repoName} && git push --force git@gitlab.synerty.com:{username}/{repoPath}.git master"
    )

    # protect master again
    print(repoNameWithNamespace)
    print(type(repoNameWithNamespace))
    r = requests.post(
        f"https://gitlab.synerty.com/api/v4/projects/{repoId}/protected_branches?name=master",
        headers=headers,
    )
    print("protect status code: ", r.status_code)

    # remove tmp cloned repo
    os.system(f"cd {cloneRepoBasedir} && rm -rf {repoName}")


def gitPullFromOriginMaster(repoNameWithNamespace):
    username, _, repo_path = repoNameWithNamespace.partition("/")
    repo_name = repo_path.split("/")[-1]
    cd_command = f"cd /Users/peek/dev-peek/{repo_name}"

    # git switch --discard-changes
    # Switch to the specified branch and discard any local changes to obtain a clean working copy.
    # As a general rule, your working copy does NOT have to be clean before you can use "switch".
    # However, if you have local modifications that would conflict with the switched-to branch,
    # Git would abort the switch. Using the "--discard-changes" flag will discard any of your
    # current local changes and then switch to the specified branch.
    os.system(
        f"{cd_command} && git switch --discard-changes master && git pull origin master"
    )


def main():
    results = {"originNotInSync": [], "localNotInSync": []}

    print(f"you are logged in as {_displayLoginUser()}")

    print("fetching lastest repo metadata...", end="")
    remoteForkedRepos = getRemoteForkedRepos()
    remoteForkedRepoSet = remoteForkedRepos.keys()

    localRepoSet = getLocalRepoSet()

    officialRepos = getRemoteOfficialRepos()
    officialRepoSet = officialRepos.keys()

    notExistingForks = officialRepoSet - (officialRepoSet & remoteForkedRepoSet)

    notExistingOnLocal = remoteForkedRepoSet - (remoteForkedRepoSet & localRepoSet)
    notExistingOnRemote = localRepoSet - (remoteForkedRepoSet & localRepoSet)

    print("done\n")

    inconsistency = False
    if notExistingForks:
        inconsistency = True
        print(f"Peek has these projects, but not in forks: {notExistingForks}")
    if notExistingOnLocal:
        inconsistency = True
        print(f"you forked in gitlab, but not on disk: {notExistingOnLocal}")
    if notExistingOnRemote:
        inconsistency = True
        print(f"existing on your disk, but not on gitlab forks: {notExistingOnRemote}")

    if inconsistency:
        answer = input("Do you wish to continue the git sync checks?[Y/n] ")
        if answer.lower() != "y":
            exit(1)

    for repo_path, repoTuple in remoteForkedRepos.items():
        origin_in_sync, local_in_sync = checkForkInSync(repoTuple.pathWithNamespace)
        if not origin_in_sync:
            results["originNotInSync"].append(
                {repoTuple.id: _buildGitlabUrl(repoTuple.pathWithNamespace)}
            )
            # fix origin/master
            # force_push_from_official_source_to_fork(repo_id, repo_name_with_namespace)

        if not local_in_sync:
            results["localNotInSync"].append(
                {repoTuple.id: _buildGitlabUrl(repoTuple.pathWithNamespace)}
            )
            # fix local working tree on master branch
            # git_pull_from_origin_master(repo_name_with_namespace)

    print()
    print("====== Summary ======")
    pprint(results)


if __name__ == "__main__":
    main()
