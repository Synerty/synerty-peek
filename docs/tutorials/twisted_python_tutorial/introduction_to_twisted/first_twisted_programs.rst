==========================
Our First Twisted Programs
==========================


In this document, we will introduce the concept of a Twisted reactor, implement a
simple program using a reactor,
and then implement a simple webserver using a reactor and some of the basic
networking classes available in the Twisted module.


Twisted Reactor Overview
------------------------

The Twisted :code:`reactor` is an implementation of the
`Reactor Design Pattern. <https://en.wikipedia.org/wiki/Reactor_pattern>`_
It manages an 'event loop', organizing which processes are currently
able to run, and which are being **Deferred** to ensure that while the
:code:`reactor` is waiting on one thing, other things are still being completed.

We will explore the ways that the reactor can be used  by:

#.  Setting up and then explain a simple Twisted program, to illustrate this
    functionality.

#.  Creating a simple webserver which makes use of a Twisted reactor below.


A simple Twisted program
------------------------

The absolute simplest Twisted program you could possibly make, is as follows::

    from twisted.internet import reactor
    reactor.run()


----

This starts a Twisted reactor. In simple terms, the reactor is a loop that will
wait for work to become assigned to it, and then do it.

If at any point during the work, it finds that it is waiting on something that is
**Deferred**, it will move on to the next thing in its queue. When the **Deferred**
object finally resolves into something, it will be notified and *react* to the change.

This way, it never leaves any work waiting while something out of its control is being
completed.

Of course, right now, our reactor has not been given any work at all, so it will
simply run silently until the process is halted. If you have not already done so,
close it down now.

Now that that you have implemented a simple twisted reactor program, we can move
on to creating something a little more complex.


A simple Twisted server
-----------------------

Now, we are going to use Twisted to build a simple web server.

Copy and paste the following code into a new project::

    from twisted.internet import reactor
    from twisted.internet.protocol import Protocol
    from twisted.internet.protocol import ServerFactory
    from twisted.internet.endpoints import TCP4ServerEndpoint


    class ServerProtocol(Protocol):

        def connectionMade(self):
            print("New Connection")
            self.transport.write(b"Hello Twisted")
            self.transport.loseConnection()


    class TutorialServerFactory(ServerFactory):

        def buildProtocol(self, addr):
            print(addr)
            return ServerProtocol()


    if __name__ == '__main__':
        endpoint = TCP4ServerEndpoint(reactor, 2000)
        endpoint.listen(TutorialServerFactory())
        reactor.run()


----

Run the above code block. While it is running, open your web browser and navigate to:

`http://localhost:2000/ <http://localhost:2000/>`_


You should see a message that says "Hello Twisted", indicating that your Twisted
web server is up and running.

But how did we get here?

Let's break it down step by step.

----

::

    from twisted.internet import reactor
    from twisted.internet.protocol import Protocol
    from twisted.internet.protocol import ServerFactory
    from twisted.internet.endpoints import TCP4ServerEndpoint

These lines all ensure that the right libraries are imported from Twisted to be used
in our code. First comes the reactor to manage our simple event loop, then
protocols and endpoints for communicating through a network.
It's OK if you don't understand these yet, as you use the various Twisted
libraries more, you will become familiar with them.

----

::

    class TutorialServerFactory(ServerFactory):
        def buildProtocol(self, addr):
            print(addr)
            return ServerProtocol()


The :code:`TutorialServerFactory` class inherits from :code:`Protocol.ServerFactory`.

When a :code:`ServerFactory` (or any subclass of Protocol) is initialized, it calls
:code:`buildProtocol`, which usually creates an instance of a Protocol object for us.

By defining :code:`buildProtocol` locally, We have overridden it to have it to
print out the address that it is being connected to from and return an instance of
our own :code:`ServerProtocol` class.

::

    class ServerProtocol(Protocol):
        def connectionMade(self):
            print("New Connection")
            self.transport.write(b"Hello Twisted")
            self.transport.loseConnection()


The :code:`ServerProtocol` class inherits from :code:`protocol.Protocol`.
The Protocol class provides Twisted's networking protocols and has several inbuilt
functions that fire at predefined times. The one we take advantage of in our example
is :code:`connectionMade()` which runs every time someone connects (or reconnects)
to the server.

There are other, similar functions within Protocol, like :code:`connectionLost()`,
but we will not be using them for now.

As you can see, every time a connection is made, our Server class will fire
:code:`connectionMade()` which will print "New Connection" to the console, and then
call :code:`self.transport.write()`, which sends the message you see in your
browser window, before finally dropping the connection with
:code:`self.transport.loseConnection()`.

----

This part is only ever run if the script is run directly, which in our case it is.

::

    if __name__ == '__main__':
        endpoint = TCP4ServerEndpoint(reactor, 2000)
        endpoint.listen(TutorialServerFactory())
        reactor.run()

This code block:

#.  Creates a :code:`TCP4ServerEndpoint` which uses Twisted's :code:`reactor` to keep
    track of its event loop, and listens on port 2000.

#.  Defines the protocol family that it will use to listen to the TCP endpoint
    (our :code:TutorialServerFactory`).

#.  Starts the :code:`reactor`, which waits until our endpoints schedule something
    for it to do, and then it does them.

Although it implements the Twisted reactor, right now our server is only behaving
synchronously. This is because we have not attempted to actually do anything
asynchronously yet.

Next, we will introduce the concept of a **Deferred** and implement some
**asynchronous** functions.
