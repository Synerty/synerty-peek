=============
Thread Checks
=============

VortexPy allows the user to easily check which thread things are running in and
ensure that the correct thread is being used.


isMainThread
------------


Explanation
'''''''''''
Returns :code:`True` if the caller is in the main thread, otherwise returns
:code:`False`


Returns
'''''''
:code:`bool`


Usage
'''''
:code:`isMainThread()`


noMainThread
------------


Explanation
'''''''''''

Ensure the caller **IS NOT** running in the main thread, raise an Exception if it is.


Returns
'''''''

:code:`None`


Usage
'''''

:code:`noMainThread()`


yesMainThread
-------------


Explanation
'''''''''''

Ensure the caller **IS** running in the main thread, raise an Exception if it is not.


Returns
'''''''

:code:`None`


Usage
'''''

:code:`yesMainThread()`


Example
-------

Code Sample
'''''''''''

::

    from vortex.DeferUtil import deferToThreadWrapWithLogger, isMainThread, noMainThread, yesMainThread
    from twisted.internet import reactor
    import logging


    logger = logging.getLogger(__name__)

    @deferToThreadWrapWithLogger(logger)
    def notInMainThread():

        # isMainThread returns a bool indicating whether it is in the main thread
        print("notInMainThread running in main thread:", isMainThread())

        # noMainThread does not return a bool,
        # it raises an exception if it is in the main thread.
        noMainThread()


    def inMainThread():

        # isMainThread returns a bool indicating whether it is in the main thread
        print("inMainThread running in main thread:", isMainThread())

        # yesMainThread does not return a bool,
        # it raises an exception if it is not in the main thread.
        yesMainThread()


    if __name__ == "__main__":

        reactor.callLater(0.1, notInMainThread)
        reactor.callLater(0.1, inMainThread)
        reactor.callLater(3.2, reactor.stop)
        reactor.run()


Output
''''''
::

    inMainThread running in main thread: True
    notInMainThread running in main thread: False

