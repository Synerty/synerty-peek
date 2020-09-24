=========================
Deferred Inline Callbacks
=========================

As we learned in our first Twisted asynchronous tutorial, Deferreds are happy to
step aside while they are waiting for something and allow other things to execute
out of order. This is not always desired.

Twisted's :code:`@inlineCallback` wrapper allows the user to pause the execution of
anything which results in a deferred and wait for the deferred to resolve using the
:code:`yield` keyword.


When to use it
--------------

When the *final* resolved value of something is required in order to safely continue.
`These are used frequently in Peek. <https://gitlab.synerty.com/peek/peek-abstract-chunked-index/-/blob
/master/peek_abstract_chunked_index/private/client/controller/ACICacheControllerABC.py#L63>`_


How to use it
-------------

Below, we create a function that uses :code:`@inlineCallBacks` and a function that
does not::

    from twisted.internet.defer import inlineCallbacks
    from twisted.internet.task import deferLater
    from twisted.internet import reactor

    from twisted.trial import unittest


    class InlineExampleTest(unittest.TestCase):

        @inlineCallbacks
        def testWithInlineCallback(self):

            d = yield deferLater(reactor, 2, lambda: True)
            print(d)
            print("x")
            return d

        def testWithoutInlineCallback(self):
            d = deferLater(reactor, 2, lambda: True)
            d.addCallback(print)
            print(d)
            print("x")
            return d


When :code:`testWithInlineCallback` is run, it should print True, followed by x,
indicating that execution was put on hold while d resolved, resulting in an output
like this::

    True
    x

    Ran 1 test in 2.007s

    OK

On the other hand, :code:`testWithoutInlineCallback` should immediately print a
Deferred object, then x, and then finally True, indicating that progress was able to
continue before it resolved, with an output similar to this::

    <Deferred at 0x10f300c88>
    x
    True

    Ran 1 test in 2.007s

    OK

