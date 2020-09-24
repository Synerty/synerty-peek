=======================
Introduction to Twisted
=======================


This tutorial is here to help new users to become familiar with using the twisted
library to write asynchronous programs in Python.


Opening Assumptions
-------------------

This tutorial assumes that you:

#.  Have set up a Python development environment.
#.  Have at least a basic level of familiarity with the Python programming language
    and Object Oriented programming.


What is Twisted?
----------------

Twisted is an **asynchronous** networking framework for Python, as opposed to
synchronous.

Synchronous computing is when each event happens after the preceding event finishes.
Thing 1 always follows Thing 2. But what happens if Thing 1 takes 10 seconds to
complete and 7 seconds of that is spent waiting for a response from something else,
as is often the case in networking? Thing 2 has to wait. In some situations this is
acceptable, but in others we need for Thing 2 to happen as soon as possible.

This is where **asynchronous** frameworks like Twisted become useful. With Twisted's
ability to **defer** tasks until they are ready, it is entirely possible for a
chain of events to look like this:

- Thing 1 fires

 - Thing 2 fires
 - Thing 2 returns

- Thing 1 returns

As you can imagine, this has the potential to save a lot of time, especially in
situations where users absolutely cannot be waiting longer than necessary for
information.

So, how do we accomplish this with Twisted? Strap in and find out.


Installing Twisted
------------------

In order to use Twisted, you will need to install it. We will be using pip to do so.
Start by opening a terminal in your project directory on Mac or Linux and entering::

 pip install twisted

This will download and install twisted. When this completes, you will be able to
import twisted inside of your project. Now we can begin to use Twisted to write
programs.


Unit Tests
----------

For the sake of brevity, many of the examples
provided in this tutorial will take place inside of unit-tests, which
will automatically take care of instantiating, starting, and stopping Twisted's
reactor. Please note this when implementing these examples inside
of your own programs.
