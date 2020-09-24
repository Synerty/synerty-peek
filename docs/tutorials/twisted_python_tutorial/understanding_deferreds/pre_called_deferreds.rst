====================
Pre-Called Deferreds
====================

Twisted allows users to create instances of 'pre-called' Deferreds by
calling :code:`defer.succeed(someValue)` or :code:`defer.fail(errorType)`,
this is a convenience feature that is the same as calling::

    d = defer.Deferred()
    d.callback(someValue)

for :code:`defer.succeed()` or::

    d = defer.Deferred()
    d.errback(errorType)

for :code:`defer.fail()`


example
'''''''

Below we have created a pre-called Deferred, and a pre-failed Deferred::

    from twisted.internet.defer import CancelledError, fail, succeed
    from twisted.trial import unittest


    class ExampleTests(unittest.TestCase):

        def testPreCalledSuccess(self):

            # Create a deferred that has already resolved
            deferredPreCalledSuccess = succeed("OK")

            # Create a Deferred and Cancel it
            deferredPreCalledFail = fail(1)

            # Returning a pre-cancelled Deferred fails with a CancelledError
            self.assertEqual("OK", deferredPreCalledSuccess.result)
            self.assertFailure(deferredPreCalledFail, int)

Running the code should result in the test passing similarly to below::

    Ran 1 test in 0.151s

    OK

Our :code:`self.assertFailure` function passing on our :code:`preCalledFail`,
would normally indicate that at some point during normal operation it
had raised an exception and become a Failure instance.

Our :code:`preCalledSuccess` having a result would normally indicate that
it had resolved with a result of "OK". In both cases we were able to skip past
these steps and simply return a pre-fired Deferred.
