import random
from datetime import datetime
from pprint import pprint

import requests
from twisted.internet import defer
from twisted.internet.defer import Deferred, DeferredList
from twisted.python.failure import Failure

random.seed(1)


class UnexpectedAnswerError(ValueError):
    def __init__(self, resp=None):
        super(UnexpectedAnswerError, self).__init__()
        self.respJson = resp


class WhoGotItFirst(object):
    URL = "https://yesno.wtf/api"

    class UnexpectedAnswerException(Exception):
        def __init__(self, resp=None):
            self.resp = resp

    def __init__(self):
        self._deferredList = None
        self._deferreds = []

    def getAll(self):
        self._deferreds = [
            self._makeDeferred(self.URL, rejectAnswerNo=False) for _ in range(3)
        ]
        #
        # Q1: your code starts HERE
        #
        #
        # Q1： your code ends HERE
        #
        self._deferredList.addCallback(pprint)

    def getFirstYes(self):
        self._deferreds = [
            self._makeDeferred(self.URL, rejectAnswerNo=True) for _ in range(3)
        ]
        self._deferredList = DeferredList(
            self._deferreds, fireOnOneCallback=True
        )
        self._deferredList.addCallback(pprint)

    def _makeDeferred(self, url, rejectAnswerNo=False) -> Deferred:
        d = defer.succeed(url)
        d.addCallback(self._getJsonUrl)
        d.addCallback(self._maskJson)
        if rejectAnswerNo:
            d.addCallback(self._filterAnswer)
            d.addErrback(self._handleUnexpectedAnswer)
        return d

    def _getJsonUrl(self, url) -> dict:
        reqTimestamp = datetime.now()
        r = requests.get(url)
        respTimestamp = datetime.now()
        jsonResult = r.json()
        # inject meta
        jsonResult["meta"] = {}
        jsonResult["meta"]["reqTime"] = str(reqTimestamp)
        jsonResult["meta"]["respTime"] = str(respTimestamp)
        jsonResult["meta"]["duration"] = (
            respTimestamp - reqTimestamp
        ).total_seconds()
        return jsonResult

    def _maskJson(self, jsonResult) -> dict:
        keepKeys = {"meta", "answer"}
        keysToBeRemoved = []
        for key in jsonResult.keys():
            if key not in keepKeys:
                keysToBeRemoved.append(key)

        for k in keysToBeRemoved:
            del jsonResult[k]
        return jsonResult

    def _filterAnswer(self, jsonResult) -> dict:
        #
        # Q2: your code starts HERE
        #
        #
        # Q2: your code ends HERE
        #
        pass

    def _handleUnexpectedAnswer(self, failure):
        self._displayUnexpectedAnswer(failure)
        #
        # Q3: your code starts HERE
        #
        #
        # Q3: your code ends HERE
        #

    def _displayUnexpectedAnswer(self, failure):
        print("received a No")
        #
        # Q4: your code starts HERE
        #
        #
        # Q4: your code ends HERE
        #


def main():
    print("ALL RESULTS:")
    WhoGotItFirst().getAll()
    print()
    print("THE FIRST YES:")
    WhoGotItFirst().getFirstYes()


if __name__ == "__main__":
    main()
