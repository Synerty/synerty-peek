from twisted.internet import defer


def print1(string):
    print("print from d1: ", string)
    return string


def print2(string):
    print("print from d2: ", string)
    return string


def print3(string):
    print("print from d3: ", string)
    return string


def setup():
    d1 = defer.Deferred()
    d1.addBoth(print1)
    d2 = defer.Deferred()
    d2.addBoth(print2)
    d3 = defer.Deferred()
    d3.addBoth(print3)
    #
    # your code starts HERE
    #
    d1.chainDeferred(d2.chainDeferred(d3))
    #
    # your code ends HERE
    #
    return d1


if __name__ == "__main__":
    d = setup()
    d.callback("test")
