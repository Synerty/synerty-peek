#!/usr/bin/env python

import json

from twisted.internet.protocol import Protocol, Factory
from twisted.protocols.basic import LineReceiver
from twisted.internet import reactor


### Protocol Implementation


class IdentityProtocol(Protocol):
    line_delimiter = LineReceiver.delimiter
    payload = ""

    def __init__(self, factory):
        self._factory = factory

    def connectionMade(self):
        self._peer = self.transport.getPeer()
        self._factory.add_record(self._peer.host, self._peer.port)

    def dataReceived(self, data):
        if data.strip() == b"show log":
            self.payload = self.makeLog()
        else:
            self.payload = self.makeIdentityResponse(data)
        self.transport.write(self.payload)
        self.transport.loseConnection()

    def makeIdentityResponse(self, data):
        data = data.decode("utf-8").strip()
        payload = 'You are from {ip} on port {port}, saying "{req}"'.format(
            ip=self._peer.host, port=self._peer.port, req=data
        )
        payload = self._encode_string(payload)
        payload += self.line_delimiter
        return payload

    def makeLog(self):
        payload = json.dumps(
            self._factory.history, ensure_ascii=True, separators=(",", ":")
        )
        return self._encode_string(payload) + self.line_delimiter

    def _encode_string(self, string, encoding="utf-8"):
        return string.encode(encoding)


class IdentityFactory(Factory):
    history = []

    def buildProtocol(self, addr):
        return IdentityProtocol(self)

    def add_record(self, ip, port):
        self.history.append({"ip": ip, "port": port})


def main():
    reactor.listenTCP(8000, IdentityFactory())
    reactor.run()


if __name__ == "__main__":
    main()
