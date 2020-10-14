import requests
import twisted
from twisted.internet import defer
from twisted.internet import task, reactor
from twisted.internet.defer import inlineCallbacks, CancelledError
from twisted.trial import unittest


def getUrl(url):
    return url


def requestUrl(url) -> requests.Response:
    return requests.get(url)


def parseContent(resp) -> str:
    return resp.content.decode(resp.encoding)


def minifyHTML(source) -> str:
    lines = []
    for line in source:
        lines.append(line.strip())
    return "".join(lines)


def synchronousCall(url) -> str:
    r = requestUrl(url)
    source = parseContent(r)
    return minifyHTML(source)


# Q1: implement the same logic in function "synchronousCall" with Deferred.
def chainedCall(url) -> defer.Deferred:
    d = defer.maybeDeferred(getUrl, url)
    d.addCallback(requestUrl)
    d.addCallback(parseContent)
    d.addCallback(minifyHTML)
    return d


# Q2: refactor function async using inlinecallbacks
@inlineCallbacks
def chainedCallInline(url) -> defer.Deferred:
    d = yield chainedCall(url)
    return d


class HTTPClientQuestions(unittest.TestCase):
    url = "https://www.example.com"
    expected = synchronousCall(url)

    def _assertHTMLBody(self, result):
        self.assertEqual(result, self.expected)

    def _assertFailure(self, result, failure):
        self.assertFailure(result, failure)

    def testChainedCall(self):
        d = chainedCall(self.url)
        d.addCallback(self._assertHTMLBody)
        return d

    def testInlineCallback(self):
        d = chainedCallInline(self.url)
        d.addCallback(self._assertHTMLBody)
        return d


if __name__ == "__main__":
    import unittest as ut

    ut.main(HTTPClientQuestions())
