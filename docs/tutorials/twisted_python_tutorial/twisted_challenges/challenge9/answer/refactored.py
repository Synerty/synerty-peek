from twisted.internet import defer, reactor, task


def helloWorld():
    return defer.succeed("Hello World")


if __name__ == "__main__":
    d = helloWorld()
    d.addCallback(print)
