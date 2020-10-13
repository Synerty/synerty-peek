from twisted.internet import protocol, task, reactor


class HeartbeatProtocol(protocol.Protocol):
    def connectionMade(self):
        #
        # your code starts HERE
        # hint: it requires reactor.clock for each session
        #
        # your code ends HERE
        #
        pass

    def connectionLost(self, reason):
        self._heartbeater.stop()


class HeartbeatProtocolFactory(protocol.Factory):
    protocol = HeartbeatProtocol

    def __init__(self, reactor):
        self._reactor = reactor


if __name__ == "__main__":
    reactor.listenTCP(5000, HeartbeatProtocolFactory(reactor))
    reactor.run()
