==================
ensureDeferredWrap
==================


Explanation
-----------
This is a decorator that ensures an asyncio function will return a Deferred.
It allows the use of Twisted's "ensureDeferred" function as a decorator.

This keeps async processing compatible with Twisted's reactive design while providing
support for the await/async syntax (and asyncio processing).

Returns
-------

:code:`Deferred`

Usage
-----

::

    @ensureDeferredWrap
    someFunction():

Example
-------

::

    from twisted.trial import unittest
    from twisted.internet.defer import Deferred
    from vortex.DeferUtil import ensureDeferredWrap
    import time

    class ExampleTest(unittest.TestCase):

        def testVortex(self):

            async def wait1():
                time.sleep(1)
                return True

            @ensureDeferredWrap
            async def usuallyAsync():
                return await wait1()

            d = usuallyAsync()
            self.assertIsInstance(d, Deferred)

The example should produce output similar to this::

    Ran 1 test in 1.149s

    OK


