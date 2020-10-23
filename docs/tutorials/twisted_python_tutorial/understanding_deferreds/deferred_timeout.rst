=====================
Timing-Out a Deferred
=====================

Twisted's defer.addTimeout allows a time limit to be set for the resolution of a
Deferred. If the Derferred does not resolve in the specified time, it will be
**Errback**-ed with a **CancelledError**.


When it is useful
-------------------
Deferred objects are not guaranteed to resolve in any concrete amount of time,
but often after a reasonable time limit is reached it is reasonable to assume that
something has gone wrong and that the Deferred should be **cancelled** with an
error.

As an example, consider an attempt to connect to a remote server. If the
connection is taking too long to become established, it may be better to
simply **cancel** the attempt and try again with a different server.


How to use it
-------------

Example
,,,,,,,

To add a Timeout to a Deferred, simply call :code:`addTimeout()` on the Deferred
object.

Below, inside of our unit test, we create a Deferred :code:`d` and call its
:code:`addTimeout` function, which automatically **cancels** it in 5 seconds and
uses the **reactor** to track the passage of time before cancellation.

Deferreds cancelled by :code:`addTimeout` raise a :code:`TimeoutError` AND, as they
call cancel, a :code:`CancelledError` as well. We have added assertions to our unit
test to confirm this behaviour::

    from twisted.internet import reactor
    from twisted.internet.defer import TimeoutError, CancelledError, Deferred
    from twisted.trial import unittest


    class DeferredExampleTest(unittest.TestCase):

        def testTimeOutIn5(self):
            def timeOutIn5() -> Deferred:
                d = Deferred()
                d.addTimeout(5, reactor)
                d.addErrback(print)
                return d

            # A timed-out Deferred should always raise a TimeoutError
            self.assertRaises(TimeoutError, self.addCleanup(timeOutIn5))
            self.assertRaises(CancelledError, self.addCleanup(timeOutIn5))


Sample Output
'''''''''''''
::

    Ran 1 test in 10.013s

    OK

