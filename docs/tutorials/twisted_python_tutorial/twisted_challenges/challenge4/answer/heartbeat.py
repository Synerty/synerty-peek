from twisted.internet import protocol, task, reactor


class HeartbeatProtocol(protocol.Protocol):
    def connectionMade(self):
        self._heartbeater = task.LoopingCall(self.transport.write, b"*")
        self._heartbeater.clock = self.factory._reactor
        self._heartbeater.start(interval=3.0)

    def connectionLost(self, reason):
        self._heartbeater.stop()


class HeartbeatProtocolFactory(protocol.Factory):
    protocol = HeartbeatProtocol

    def __init__(self, reactor):
        self._reactor = reactor


if __name__ == "__main__":
    reactor.listenTCP(5000, HeartbeatProtocolFactory(reactor))
    reactor.run()
