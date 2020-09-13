==================
Delaying Deferreds
==================


Twisted allows users to easily schedule functions to be called after a given
amount of time has passed. This functionality is especially powerful when used
with **Deferreds**, to enhance their asynchronous utility.


Reactor.CallLater
-----------------

The **reactor** can be used to call a function at a later date. While this
returns an **IDelayedCall**, not a Deferred, it can be used to trigger a
Deferred's callback.


How to use it
,,,,,,,,,,,,,

Below, we create a Deferred, :code:`d`, and ask the :code:`reactor` to:

#.  Wait 1 second.
#.  Call its **callback** with the argument "OK'.

While **reactor.callLater** can be used with Deferreds, it could also
invoke any function with any argument after any period of time::

    from twisted.internet import reactor, task, defer
    from twisted.trial import unittest

    class ExampleTests(unittest.TestCase):

        def testCallLater(self):

            # Creates a Deferred and has the reactor call it back
            d = defer.Deferred()
            reactor.callLater(1, d.callback, "OK")
            return d

Which should output::

    Ran 1 test in 1.006s

    OK


task.deferLater
---------------

The **twisted.internet.task** library revolves around scheduling functions
to execute at a later date, and managing these schedules. One useful
function in the **task** library is **deferLater**, which calls a function
after a given amount of time and returns a Deferred that fires with the
eventual return value of the callable function.


How to use it
,,,,,,,,,,,,,

Below, we call :code:`task.deferLater`, telling it to ask the :code:`reactor` to:

#.  Wait 1 second.
#.  call print with the argument "OK".

This returns a Deferred which will eventually fire with the result of the called
function. Because print does not return a value, :code:`d` will fire with a result
of :code:`None`::

    def testDeferLater(self):

        # Creates a Deferred and has the reactor call it back
        d = task.deferLater(reactor, 1, print, "OK")
        assert isinstance(d, defer.Deferred), "deferLater returns a Deferred"
        return d

When run, the output should look like this::

    Ran 1 test in 1.007s

    OK

    Process finished with exit code 0
    OK


task.LoopingCall
----------------

The task library contains the LoopingCall class, which can be instantiated and told to
call a given function with provided arguments. The instance of LoopingCall can have
it's :code:`start(interval, now)` function called to begin a loop of calling the
given function every interval seconds. The 'now' argument can be passed to it as a
boolean to indicate whether it should start immediately, or wait until the interval
has passed once before beginning.

`LoopingCall is used frequently within Peek.
<https://gitlab.synerty.com/peek/peek-abstract-chunked-index/-/blob/master/
peek_abstract_chunked_index/private/server/controller/
ACIProcessorQueueControllerABC.py#L78>`_


How to use it
,,,,,,,,,,,,,

The below code creates an instance of **LoopingCall**, :code:`c`, and tells it that
when it is invoked, it should call print with the argument "I'll be back".

Then, it runs :code:`c.start`, telling it to loop every 1 second. Because True is not
passed as a second argument, it will not call print immediately, but will instead
wait until 1 second has passed before beginning. :code:`c.start` returns a Deferred
which will resolve when :code:`c.stop` is called or when the function passed to
:code:`c` when it is created raises an error::

    def testLoopingCall(self):

        # Allows a function to be called repeatedly
        c = task.LoopingCall(print, "I'll be back")
        d = c.start(1)
        reactor.callLater(3, c.stop)
        return d

When run, this should output something like::

    Process finished with exit code 0
    I'll be back
    I'll be back
    I'll be back
    I'll be back


    Ran 1 test in 3.009s

    OK

