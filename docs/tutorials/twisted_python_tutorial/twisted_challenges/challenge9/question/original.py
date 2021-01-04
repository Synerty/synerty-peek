from twisted.internet import defer, reactor


def helloWorld():
    return "Hello World"


if __name__ == "__main__":
    d = defer.maybeDeferred(helloWorld)
    d.addCallback(print)
