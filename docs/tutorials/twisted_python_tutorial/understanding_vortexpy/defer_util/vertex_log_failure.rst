================
vortexLogFailure
================


Explanation
-----------

Checks to see if the `Failure <https://twistedmatrix.com/documents/current/api/
twisted.python.failure.Failure.html>`_
object passed to it as :code:`failure` has already been assigned the attribute
:code:`_vortexLogged`.
If it has not, then the `Logger <https://twistedmatrix.com/documents/current/api/
twisted.logger.Logger.html#error>`_
passed to it as :code:`loggerArg` will be called and will emit a log event.

Finally, if consumeError is :code:`True`, then it will return :code:`SuccessValue`,
otherwise,
:code:`failure` will be returned.

Returns
-------

Either :code:`successValue` if successful or :code:`failure` if not.

Usage
-----

:code:`vortexLogFailure(failure, loggerArg, consumeError=False, successValue=True)`

vortexLogFailure is used to easily log a Failure that had not already been logged by
vortex.

Example
-------

::

    from twisted.trial import unittest
    from twisted.internet import defer
    from vortex.DeferUtil import vortexLogFailure
    import logging


    logger = logging.getLogger(__name__)

    class ExampleTest(unittest.TestCase):

        def testVortex(self):s

            def alwaysFails():
                d = defer.Deferred()
                d.addErrback(vortexLogFailure, logger, consumeError = True)
                d.errback(1)
            alwaysFails()

The example should produce output similar to this::

    Ran 1 test in 0.103s

    OK
    Traceback (most recent call last):
    Failure: builtins.int: 1

