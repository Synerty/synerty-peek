from twisted.internet import defer, task


def logTimeout(result, timeout):
    print(f"got '{result}', but after {timeout} seconds")
    return result + "(timed out)"


def main(reactor):
    d = defer.Deferred(lambda c: c.callback("Everything's ok!"))
    #
    # your code starts HERE
    # hint: addTimeout
    #
    d.addTimeout(2, reactor, onTimeoutCancel=logTimeout)
    #
    # your code ends HERE
    #
    d.addBoth(print)
    return d


if __name__ == "__main__":
    task.react(main)
