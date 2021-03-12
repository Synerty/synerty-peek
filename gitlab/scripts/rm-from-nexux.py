import re
import sys
from collections import namedtuple
from typing import List

import requests
from requests.auth import HTTPBasicAuth

NEXUS_REPOSITORY_URL = sys.argv[1]
NEXUS_USERNAME = sys.argv[2]
NEXUS_PASSWORD = sys.argv[3]
PACKAGE_NAME = sys.argv[4]

print(f"Using URL: {NEXUS_REPOSITORY_URL}")

PACKAGE_PATTERN = re.compile(f"{PACKAGE_NAME}.*?.tar.gz")

NEXUS_REPOSITORY_URL = NEXUS_REPOSITORY_URL + "/service/rest/v1/assets"
listAssetUrl = f"{NEXUS_REPOSITORY_URL}?repository=pypi-internal"
auth = HTTPBasicAuth(NEXUS_USERNAME, NEXUS_PASSWORD)

Artifact = namedtuple("Artifact", ["path", "id"])
toBeDeletedArtifacts = []


def deleteArtifect(artifacts: List[Artifact]):
    if not artifacts:
        print(f"No old {PACKAGE_NAME} artifacts found, skip")
        return

    for artifact in artifacts:
        url = f"{NEXUS_REPOSITORY_URL}/{artifact.id}"
        r = requests.delete(url, auth=auth)
        if r.status_code == 204:
            print(f'DELETED "{artifact.path}"')


def searchInArtifacts(continuationToken=""):
    url = listAssetUrl

    if continuationToken:
        url = f"{listAssetUrl}&continuationToken={continuationToken}"
    r = requests.get(url, auth=auth)
    json_ = r.json()

    for item in json_.get("items", []):
        itemPath = item.get("path", "")
        matched = PACKAGE_PATTERN.search(itemPath)
        if matched:
            itemId = item.get("id", "")
            toBeDeletedArtifacts.append(Artifact(path=itemPath, id=itemId))

    if cToken := json_.get("continuationToken"):
        searchInArtifacts(continuationToken=cToken)


searchInArtifacts(continuationToken="")
deleteArtifect(toBeDeletedArtifacts)
