==============
Common Gotchas
==============

Deferreds can occasionally throw up some surprises by exhibiting behaviours that are
not bugs, but are also likely to be different than the intended outcome the user
was hoping to achieve. Because a lot of these mistakes are caught by unit tests,
the examples provided in this section will not occur within a unit test, but instead
within a typical reactor loop.


:code:`yield` not returning anything
------------------------------------

Inside of an @inlineCallback wrapper, the :code:`yield` keyword can be used to tell
the program to wait for a Deferred or anything that returns a Deferred, to resolve
before continuing. If you forget to add the wrapper, however, a generator object
will be returned instead.


example
'''''''

In our example below, we assign the variable :code:`username` to the return of
:code:`yieldWithoutInlineCallbacks():`, which does not return the name we were
hoping for, but instead returns a generator object::

    from twisted.internet import reactor, defer


    def yieldWithoutInlineCallbacks():

        # We create a Deferred
        d = defer.Deferred()

        # Pretend to enter a name
        d.callback("Jimmy")

        # Accidentally call yield without @inlineCallbacks
        yield d
        return d


    if __name__ == "__main__":

        # This function will return a generator object instead of a yielded Deferred, and we never noticed.
        username = yieldWithoutInlineCallbacks()

        # Some time later...
        print("Hello,", username)
        reactor.run()


----

When run, the above code block outputs something like::

    Hello, <generator object yieldWithoutInlineCallbacks at 0x10977e1b0>

Probably not what we had in mind...

Not waiting for a function that returns a Deferred
--------------------------------------------------

Because Deferreds are not generally intended to be waited for, instead using
callbacks to continue whenever they are ready, at some points a user may
accidentally forget to wait for a Deferred when the program is not intended to
continue until the Deferred has been called. This can result in strange behavior.


example
'''''''

Here we create a Deferred that is intended to get a username. We add
:code:`getUsername` to it as a callback, but we forget to wait for it to come back
(in this example we don't call it at all). Because of this, it is assigned to the
variable username, which is then printed, leading odd output::

    from twisted.internet import reactor, defer


    def returnUncalledDeferred() -> defer.Deferred:

        def getUsername():

            # The callback that is never called
            return "Jimmy"

        # We create a Deferred
        d = defer.Deferred()

        # Add a callback that will get a name
        d.addCallback(getUsername)

        # Accidentally return the Deferred before called its callback
        return d


    if __name__ == "__main__":

        # This function will return a Deferred object instead of a username
        username = returnUncalledDeferred()
        print("Hello,", username)
        reactor.run()


----

Which results in an eventual output of::

    Hello, <Deferred at 0x10671c0f0>

Because the Deferred did not raise an exception, and does not list the place that the
Deferred originated like in the yield example, this can be a more difficult kind of
mistake to track down.

