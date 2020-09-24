===========================
deferToThreadWrapWithLogger
===========================


Explanation
-----------

This method is a decorator used to send blocking methods to threads easily.``
This can only be done from the main thread inside of the reactor event loop.


Returns
-------

:code:`Deferred`


Usage
-----

::

            import logging
            logger = logging.getLogger(__name__)
            @deferToThreadWrapWithLogger(logger)
            def myFunction(arg1, kw=True):
                pass


Example
-------

This example did not take place in a unit test, as functions that are not used
inside of Twisted's main reactor loop cannot be deferred to a separate thread.

As you can see by the output, the method :code:`usuallyBlocking` below is moved to
another thread by :code:`@deferToThreadWrapWithLogger` removing the blockage and
allowing the reactor to continue.

::

    from vortex.DeferUtil import deferToThreadWrapWithLogger
    from twisted.internet import reactor
    import time, logging


    logger = logging.getLogger(__name__)

    @deferToThreadWrapWithLogger(logger)
    def usuallyBlocking():
        time.sleep(2)
        print("Blocker ran outside of main thread")


    if __name__ == "__main__":

        reactor.callLater(1, usuallyBlocking)
        reactor.callLater(1.1, print, "Runs in Main Thread")
        reactor.callLater(3.2, reactor.stop)
        reactor.run()


Output
------

The example should produce output similar to this::

    Runs in Main Thread
    Blocker ran outside of main thread

