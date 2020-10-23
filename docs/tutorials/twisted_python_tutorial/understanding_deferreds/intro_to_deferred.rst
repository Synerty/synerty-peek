========================
Introduction to Deferred
========================

In this section we will examine a brief overview of what Twisted's Deferred object
is and what it does, before implementing it in a way that shows how it can be used
to gain a performance advantage over synchronous code.


What is a Deferred?
-------------------

A Deferred is an object that represents a promise that at some point it will resolve
into another kind of object. Deferred's allow the reactor to avoid spending time
waiting for something outside of its control to complete.


A Synchronous Problem
---------------------

Examine the following **synchronous** code block::

    import time


    def printMe(value):
        print(value)


    def waitFive(name) -> str:
        value = name + " took 5 seconds"
        time.sleep(5)
        return value


    def waitTen(name) -> str:
        value = name + " took 10 seconds"
        time.sleep(10)
        return value


    print("Starting: ")

    # Define two variables that will take a while to resolve
    slow = waitTen("'slow'")
    fast = waitFive("'fast'")

    printMe(slow)
    printMe(fast)

This represents a standard, synchronous situation. "slow" is assigned the value
returned by waitTen() and then "fast" is assigned the value returned by
waitFive(). Things always happen after the previous thing finishes and in total,
the program takes 15 seconds to complete. The vast majority of that time is spent
waiting.


A Deferred Solution
-------------------

Now, open your IDE and insert the following **asynchronous** code block::

    from twisted.internet import reactor, defer


    def printMe(value):
        print(value)
        return True


    def waitFive(name) -> defer.Deferred:
        value = defer.Deferred()
        reactor.callLater(5, value.callback, name + " took 5 seconds")
        return value


    def waitTen(name) -> defer.Deferred:
        value = defer.Deferred()
        reactor.callLater(10, value.callback, name + " took 10 seconds")
        return value

    print("Starting: ")

    # Define two variables that will take a while to resolve
    slow = waitTen("'slow'")
    fast = waitFive("'fast'")

    # Show that they are being Deferred
    print("slow is: ", slow)
    print("fast is: ", fast)

    # Give them callbacks
    slow.addCallback(printMe)
    fast.addCallback(printMe)

    reactor.run()


----

Run it and after a few seconds you should see the following result::

    Starting:
    slow is:  <Deferred at 0x7f57b1833340>
    fast is:  <Deferred at 0x7f57b16eee50>
    'fast' took 5 seconds
    'slow' took 10 seconds

As you can see, both variables were assigned Deferred objects immediately after
\their creation the variable "fast" was printed before "slow" this time, and as a
result, the values are returned in 10 seconds. We saved 5 seconds in execution
time! But how did we get here?

----

The first thing you may have noticed is that this time in addition to the reactor,
we also imported defer from twisted.internet.

    from twisted.internet import reactor, defer

This allows us to use Twisted's Deffered objects.


Take a look at one of the wait functions.

::

    def waitTen() -> defer.Deferred:
        value = defer.Deferred()
        reactor.callLater(10, value.callback, "I took 10 seconds")
        return value

Instead of a string like in our synchronous example, value is assigned a
:code:`defer.Deferred()` object. This allows us to return a placeholder object
immediately, so that we can keep processing while the actual value is determined
and passed back to it. Then, to simulate a long wait, the reactor is asked via
:code:`callLater` to come back to our Deferred in 10 seconds, assigning it the value
"I took 10 seconds" and starting its **callback chain**. As soon as this request
is made, value is returned and assigned to "slow".

----

::

    slow = waitTen()
    fast = waitFive()

    ...

::

    slow.addCallback(printMe)
    fast.addCallback(printMe)

Because "slow" is immediately assigned a value, we are able to move forward and
assign "fast", to the output of waitFive(), which returns a Deferred in exactly
the same way, only after 5 seconsd instead of 10.

5 and 10 seconds later respectively, the reactor calls the Deffered's callback(any)
function, passing each of them a string and triggering their waiting callbacks, which
in this case are both "printMe()". Because "fast" finished first, it was printed
first, and "slow", although it was started first, was printed after.
