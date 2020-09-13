======================
Using The DeferredList
======================

The Twisted **DeferredList** is a subclass of Deferred that acts as aList of
Deferreds. When the final Deferred in the last has fired, the **DeferredList** will
call any **callbacks** that have been added to it and resolve into a 'resultList'
with the format [(bool, value)] indicating for each Deferred whether the Deferred
succeeded or failed and the final value of the Deferred.


When to use it
--------------

A **DeferredList** is useful for when you want to monitor the state of -or add the
same callback to- a group of Deferreds.
`These are used in Peek. <https://gitlab.synerty.com/peek/peek-abstract-chunked-index
/-/blob/master/peek_abstract_chunked_index/private/client/controller/
ACICacheControllerABC.py#L66>`_


How to use it
-------------

When run, the below functions should perform similarly, printing the resolved values
of both the Deferreds in the **DeferredList** and the regular Deferreds, but for a
large number of Deferreds, the **DeferredList** is able to save many lines and
provides added functionality. Note that when used with the :code:`@inlineCallbacks`
wrapper, the entire DeferredList can be yielded, as opposed to each Deferred
needing to be yielded individually.::

    from twisted.internet.defer import DeferredList, inlineCallbacks
    from twisted.internet.task import deferLater
    from twisted.internet import reactor
    from twisted.trial import unittest


    class InlineExampleTest(unittest.TestCase):

        def testWithDeferredList(self):

            # Manage multiple Deferreds with a  DeferredList
            d1 = deferLater(reactor, 1, lambda: "Called1")
            d2 = deferLater(reactor, 2, lambda: "Called2")
            dList = DeferredList([d1, d2])
            dList.addCallback(print)
            return dList

        @inlineCallbacks
        def testWithInlineDeferredList(self):

            # Manage multiple Deferreds with a  DeferredList
            d1 = deferLater(reactor, 1, lambda: "Called1")
            d2 = deferLater(reactor, 2, lambda: "Called2")
            dList = DeferredList([d1, d2])
            dList.addCallback(print)
            yield dList
            return dList

        @inlineCallbacks
        def testWithoutDeferredList(self):

            # Manage multiple Deferreds without a  DeferredList
            d1 = deferLater(reactor, 1, lambda: "Called1")
            d2 = deferLater(reactor, 2, lambda: "Called2")
            d1.addCallback(print)
            d2.addCallback(print)
            yield d1
            yield d2
            return d1, d2



----

:code:`testWithDeferredList` should output something like::

    Ran 1 test in 2.008s

    OK

    Process finished with exit code 0
    [(True, 'Called1'), (True, 'Called2')]

----

:code:`testWithInlineDeferredList` should output something like::

    [(True, 'Called1'), (True, 'Called2')]
    Ran 1 test in 2.009s

    OK

----

:code:`testWithoutDeferredList` should output something like::

    Called1


    Ran 1 test in 2.007s

    OK
    Called2


Other Useful Information: Parameters
------------------------------------

When the DeferredList is created, it can be passed a List of Zero or more Deferreds
followed by a number of parameters.

fireOnOneCallback
'''''''''''''''''

Fires the list's callbacks as soon as a single Deferred inside of it succeeds.
This is useful if you need to know immediately whether or not any Deferred has
succeeded.

fireOnOneErrback
''''''''''''''''

More commonly used than **fireOnOneCallback**. Fires the list's callbacks as soon
as a single Deferred inside of it is failed. This is useful if you need to know
immediately whether or not any Deferred has failed.

consumeErrors
'''''''''''''

Can still be used with **fireOnOneErrback**. Prevents individual Deferreds from
firing their errback chains. Instead errbacks are converted to callback results
of None. This serves to prevent a large number of unhandled error messages from
being logged.
