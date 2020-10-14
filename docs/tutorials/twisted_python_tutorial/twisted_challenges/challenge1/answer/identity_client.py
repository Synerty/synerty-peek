#!/usr/bin/env python

from twisted.internet import task
from twisted.internet.defer import Deferred
from twisted.internet.protocol import ClientFactory
from twisted.protocols.basic import LineReceiver


class IdentityClient(LineReceiver):
    def connectionMade(self):
        payload = input("type your message: ").encode("utf-8")
        self.sendLine(payload)

    def lineReceived(self, line):
        print("receive:", line)
        self.transport.loseConnection()


class IdentityClientFactory(ClientFactory):
    protocol = IdentityClient

    def __init__(self):
        self.done = Deferred()

    def clientConnectionFailed(self, connector, reason):
        print("connection failed:", reason.getErrorMessage())
        self.done.errback(reason)

    def clientConnectionLost(self, connector, reason):
        print("connection lost:", reason.getErrorMessage())
        self.done.callback(None)


def main(reactor):
    factory = IdentityClientFactory()
    reactor.connectTCP("localhost", 8000, factory)
    return factory.done


if __name__ == "__main__":
    task.react(main)
