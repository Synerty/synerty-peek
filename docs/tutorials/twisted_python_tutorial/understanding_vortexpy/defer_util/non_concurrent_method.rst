===================
nonConcurrentMethod
===================


Explanation
-----------

This decorator ensures that method will only run once at any given time.
It will ignore subsequent calls if the method is still running.
The returned decorated method has a "running" flag which indicates whether or not
it is still running.


Returns
-------
The now-decorated argument method.


Usage
-----
::

    @nonConcurrentMethod
    someFunction():
    pass


Example
-------

::

    from vortex.DeferUtil import nonConcurrentMethod, deferToThreadWrapWithLogger
    from twisted.internet import reactor
    import time, logging


    logger = logging.getLogger(__name__)

    @deferToThreadWrapWithLogger(logger)
    @nonConcurrentMethod
    def usuallyConcurrent():
        time.sleep(2)
        print("Function Called")

    if __name__ == "__main__":

        reactor.callLater(0.1, usuallyConcurrent)
        reactor.callLater(0.1, usuallyConcurrent)
        reactor.callLater(3.5, reactor.stop)
        reactor.run()


The example should only run usuallyConcurrent once and will produce this output::

    Function Called

    Process finished with exit code 0

