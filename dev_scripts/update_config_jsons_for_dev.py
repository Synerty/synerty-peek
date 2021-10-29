#!/usr/bin/env python3
import json
import logging
import shutil
import sys
from datetime import datetime
from json import JSONDecodeError
from pathlib import Path

WEB_SERVICES = {"logic", "field", "office"}
ALL_SERVICES = {"logic", "field", "office", "agent", "worker"}

JSON_OVERRIDES_FRONTEND = {
    "docBuildEnabled": False,
    "docBuildPrepareEnabled": True,
    "docSyncFilesForDebugEnabled": True,
    "syncFilesForDebugEnabled": True,
    "webBuildEnabled": False,
    "webBuildPrepareEnabled": True,
}

JSON_OVERRIDES_LOGGING = {"level": "DEBUG", "logToStdout": True}

logging.basicConfig(stream=sys.stderr, level=logging.INFO)
logger = logging.getLogger(__name__)


def updateFrontend(configJson: dict):
    if "frontend" in configJson:
        for key, value in JSON_OVERRIDES_FRONTEND.items():
            configJson["frontend"][key] = value
    return configJson


def updateLogging(configJson: dict):
    if "logging" in configJson:
        for key, value in JSON_OVERRIDES_LOGGING.items():
            configJson["logging"][key] = value
    return configJson


def main():
    now = datetime.now()
    for serviceName in ALL_SERVICES:
        configJsonFile = Path.home() / Path(
            f"./peek-{serviceName}-service.home/config.json"
        )

        if not configJsonFile.exists():
            logger.warning(
                f"PEEK config home folder for {serviceName} not found."
            )
            continue

        configJsonFilePath = str(configJsonFile.resolve())

        backupFilePath = (
            f"{configJsonFilePath}.bak-"
            f"{now.year}-{now.month}-{now.day}_"
            f"{now.hour}{now.minute}{now.second}"
        )

        shutil.copyfile(configJsonFilePath, backupFilePath)

        try:
            configJson = json.load(open(configJsonFile, "r"))
        except JSONDecodeError:
            logger.error(f"Error parsing {configJsonFile}")
        else:
            if serviceName in WEB_SERVICES:
                configJson = updateFrontend(configJson)

            configJson = updateLogging(configJson)

            outputFile = open(str(configJsonFile.resolve()), "w")
            json.dump(
                configJson,
                outputFile,
                sort_keys=True,
                indent=4,
                separators=(",", ": "),
            )


if __name__ == "__main__":
    main()
