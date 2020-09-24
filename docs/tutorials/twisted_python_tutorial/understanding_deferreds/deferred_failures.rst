=================
Deferred Failures
=================

A Deferred is an object that represents a promise that it will eventually become
something else. Either it will be called back, and its eventual result will be the
final value returned to its callback, or it will fail and become an instance of the
`Failure class.
<https://twistedmatrix.com/documents/20.3.0/api/twisted.python.failure.Failure.html>`_

The failure class helps to circumvent some of the inconveniences that standard Python
error mechanisms cause for asynchronous programs. An instance of the Failure class
contains frames, which provide information about the file, function, and line that an
error occurred, and the Failure instance can collect multiple frames, eventually
finishing its errback chain with a stack containing one or more frames, each of
which describes an error.


Failure.value()
---------------

The exception instance responsible for causing a failure can be checked by calling
:code:`Failure.value()` on a Failure instance. This is useful for quickly identifying
the problem in situations where an initial exception has caused cascading errors.

How to use it
,,,,,,,,,,,,,

Below, we create a function :code:`assessFailValue(d)` which examines the
:code:`value` variable of the Failure to determine what to do next. We then
instantiate a Deferred with an errback and callback and then we cancel it, passing
it to :code:`assessFailValue(d)`.

:code:`assessFailValue(d)` examines the Failure instance that our Deferred has
become and determines whether or not the first exception that was raised is one that
should be handled further.

Because we are assuming in our example that a cancelled Deferred was cancelled by the
user, and is therefore not really a bad thing, and may be something we want to treat
like a callback, we can actually chain our errback into a callback with the value
"Eventual success".

This is passed back up the callback chain and 'd' finishes by firing its original
callback and printing "Eventual Success". If this last bit was a little confusing,
don't worry, we're going to learn more about it in the next tutorial.

::

    class ExampleTests(unittest.TestCase):

        def testFailureValue(self):

            # Set up a function to examine our Failure
            def assessFailValue(d) -> Deferred:

                # If the first exception is a CancelledError, a user cancelled it
                if type(d.value) == CancelledError:

                    # So we don't consider it an error past this point
                    return succeed("Eventual Success!")
                else:

                    # /continue to handle the error elsewhere/
                    return fail(1)

            #create a deferred that we will fail
            d = Deferred()
            d.addErrback(assessFailValue)
            d.addCallback(print)

            # Pretend a user cancelled our Deferred, causing it to errback
            d.cancel()
            return d

----

Which should output something like::

    Ran 1 test in 0.137s

    OK

    Process finished with exit code 0
    Eventual Success!


Failure.check()
---------------

Failures are useful for handling errbacks. For example, if a server uses a Deferred
to  make a request that eventually times out, the Deferred can errback with a
:code:`TimeoutError` and a :code:`CancelledError` and it can probably be safely
ignored. However, if that same Deferred raises a :code:`TypeError` it could be an
indication that something more important has gone wrong.

A convenient way to filter out the less important errors is the
:code:`Failure.check()` function, which checks to see if a failure instance is in a
predetermined list. If the failure is in the list, it returns the match, otherwise
it returns None. This makes it easy to create a rule that would ignore a
:code:`TimeoutError` and log or notify on a :code:`TypeError`.


How to use it
,,,,,,,,,,,,,

Below, much like in the first example, we check to see if the failure was raised by
an exception that we should be concerned about, but this time we do it using the
Failure class's inbuilt :code:`.check()` function, which returns either None, or the
kind of exception thrown, allowing us to easily check a list of exceptions (a number
of exceptions passed to the function as an argument, not a list data structure).
As in the first example, because we raised a CancelledError, the exception was
found and returned as a callback::

    def testFailureCheck(self):

        # Set up a function to examine our Failure
        def assessFailCheck(d) -> Deferred:


            # If the first exception is one we are ok with
            if d.check(TimeoutError, CancelledError, 1) != None:

                # So we don't consider it an error past this point
                return succeed("Eventual Success!")
            else:
                # /continue to handle the error elsewhere/

                return fail(1)

        #create a deferred that we will fail
        d = Deferred()
        d.addErrback(assessFailCheck)
        d.addCallback(print)

        # Pretend a user cancelled our Deferred, causing it to errback
        d.cancel()
        return d


