===========================
maybeDeferredWrap
===========================


Explanation
-----------
This is a decorator that ensures a function will return a Deferred.
It allows the use of Twisted's maybeDeferred as a decorator.

Twisted's maybeDeferred calls the given function with the given arguments and returns
either a Failure wrapped in :code:`defer.fail` if the function returns a Failure
object, or if an Exception is raised. Otherwise, the function's return is wrapped
in :code:`defer.succeed` and returned.


Returns
-------

:code:`Deferred`

Usage
-----

::

    @maybeDeferredWrap
    someFunction():


Example
-------

::

    from twisted.trial import unittest
    from twisted.internet.defer import Deferred
    from vortex.DeferUtil import maybeDeferredWrap

    class ExampleTest(unittest.TestCase):

        def testVortex(self):

            @maybeDeferredWrap
            def notUsuallyDeferred():
                return True

            d = notUsuallyDeferred()
            self.assertIsInstance(d, Deferred)

The example should produce output similar to this::

    Ran 1 test in 0.100s

    OK


