==================
Chaining Deferreds
==================

The callbacks of Deferreds can be linked via the :code:`Deferred.chainDeferred`
function. This makes it so that calling or errbacking the **first** deferred also
triggers the callback or errback of the second.

Functionally, this is the same as adding the callback and errback of the second
deferred as a callback and errback of the first respectively.

:code:`chainDeferred` is a one-way link. Calling back the second Deferred will not
trigger the first's callback unless the second has had its own :code:`chainDeferred`
function called on the first.


When to use it
--------------

When you want one Deferred to trigger the callbacks of others.


How to use it
-------------

Below we create two deferreds: :code:`deferredGetsChained`, and
:code:`deferredMakesChain`. Then we call  :code:`chainDeferred` on
:code:`deferredMakesChain` with :code:`deferredGetsChained` as an argument.

Because :code:`deferredGetsChained.callback` is now the first of
:code:`deferredMakesChain`'s callbacks, the value of :code:`deferredMakesChain` is
passed to the first callback of :code:`deferredGetsChained`, which is :code:`print`.
Because :code:`deferredGetsChained`'s callback has been triggered, it fires its
callbacks itself, resulting in it also being printed.::

    from twisted.internet import defer
    from twisted.trial import unittest


    class ExampleTests(unittest.TestCase):

        def testDeferredChaining(self):

            # Create two Deferreds
            deferredGetsChained = defer.Deferred()
            deferredMakesChain = defer.Deferred()

            # Give the chain-ee a callback
            deferredGetsChained.addCallback(print, "So was I!")

            # Chain the first Deferred to the second
            deferredMakesChain.chainDeferred(deferredGetsChained)

            # Call the first Deferred back to trigger the callback of the other
            deferredMakesChain.callback("I was called back!")

----

The output when run should look like this::

    I was called back! So was I!


Potentially unexpected behavior
'''''''''''''''''''''''''''''''

If a second Deferred were to be chained to the first, the first would be printed
twice, although its initial value would only be printed once.

In this case, :code:`None` will be the value of :code:`deferredMakesChain` at the
time that it is called for the second time, as its initial value has already been
passed to the first chained Deferred's callback. :code:`deferredMakesChain`
is still used in both callbacks and is even processed before the values of
the chained deferreds themselves::

    from twisted.internet import defer
    from twisted.trial import unittest


    class ExampleTests(unittest.TestCase):

        def testDeferredChaining(self):

            # Create two Deferreds
            deferredGetsChained = defer.Deferred()
            deferredAlsoGetsChained = defer.Deferred()
            deferredMakesChain = defer.Deferred()

            # Give the chain-ee a callback
            deferredGetsChained.addCallback(print, "So was I!")
            deferredAlsoGetsChained.addCallback(print, "Me too!")

            # Chain the first Deferred to the second
            deferredMakesChain.chainDeferred(deferredGetsChained)
            deferredMakesChain.chainDeferred(deferredAlsoGetsChained)

            # Call the first Deferred back to trigger the callback of the other
            deferredMakesChain.callback("I was called back!")



----

Which results in something like::

    Ran 1 test in 0.127s

    OK
    I was called back! So was I!
    None Me too!

