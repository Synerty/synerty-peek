=====================
Cancelling a Deferred
=====================

Cancellation causes a Deferred to be **cancelled**, usually causing an **Errback**
without the Deferred having to have naturally thrown an exception. (Note, some
operations cannot be **cancelled** and the Deferred may resolve before it is
**cancelled**)


When it is useful
-----------------

When getting the eventual result of a Deferred is not a requirement, or could even
be a hindrance. Especially if the Deferred's resolution is resource-intensive.
As an example, if a user starts to connect to a distant server and the connection
takes a long time, they may simply wish to exit the operation and attempt something
else, maybe connecting to a different server. In that case, we do not need or want
the Deferred which results from that connection anymore. We could simply ignore the
result when it resolves, but it is better for us to **cancel** it.


How to use it
-------------


Calling cancel
''''''''''''''

A deferred can be cancelled simply by calling that Deferred object's :code:`cancel()`
function

As you can see below, we create a Deferred and then immediately call its :code`cancel`
function. Running the below code block should result in it failing with a
:code:`CancelledError`. We have added an assertion to our unit test to confirm this
behaviour:

    from twisted.internet.defer import CancelledError, Deferred
    from twisted.trial import unittest


    class CancellingExampleTests(unittest.TestCase):

        def testCancelsImmediately(self):

            # Create a Deferred and Cancel it
            def cancelImmediately() -> Deferred:

                d = Deferred()
                d.cancel()
                return d

            # Returning a pre-cancelled Deferred fails with a CancelledError
            self.assertFailure(cancelImmediately(), CancelledError)


----

which outputs something like::

    Ran 1 test in 0.103s

    OK


Custom canceller
''''''''''''''''

At the time a deferred is created, a canceller can be passed to the deferred.
Below, we create a Deferred, :code:`d`,  and pass a function as an argument to its
:code:`__init__(self, canceller)` function. This assigns :code:`printCancelled` as our
custom canceller. We then set an **errback**, and tell :code:`d` to  timeout in
5 seconds. 5 seconds after running it, the timeout should **cancel** :code:`d`, which
is then passed to the custom canceller::

    def testCustomCanceller(self):

        # The Custom Canceller function
        def printWhenCancelled(d: Deferred) -> Deferred:
            print("I was Cancelled")
            return d

        # Add a custom canceller and immediately call it
        def createWithCusomCanceller() -> Deferred:
            d = Deferred(printWhenCancelled)
            d.cancel()
            return d

        self.assertFailure(createWithCusomCanceller(), CancelledError)

----

which outputs something like::

    OK
    I was Cancelled

Our custom canceller might have been expected to avoid calling an **errback**, as we
specified which canceller would be called.`This is not necessarily the case
<https://github.com/twisted/twisted/blob/twisted-20.3.0/src/twisted/internet/
defer.py#L522>`_.
If a callback is not called explicitly, it will eventually **fail** and **errback**
as a **CancelledError**. We added a test case to the unit test to demonstrate this.

Running this should cause the createWithCusomCanceller function to be run
and failed with a **CancelledError**, but first, printWhenCancelled should
be called as the canceller and print "I was Cancelled".
