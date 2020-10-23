=============================
The Twisted Reactor Explained
=============================


Twisted's reactor is the object that controls the main event loop. It allows data
to be processed **asynchronously** and it loosely follows the titular
`Reactor Design Pattern. <https://en.wikipedia.org/wiki/Reactor_pattern>`_


What are the benefits
---------------------

The Twisted reactor has two main benefits.

 #. Asynchronous computing.
 #. It implements a `select loop <https://en.wikipedia.org/wiki/Asynchronous_I/
    O#Select.28.2Fpoll.29_loops>`_
    and not a `busy loop <https://en.wikipedia.org/wiki/Busy_waiting>`_.
    This means that while idle, the reactor will not consume CPU by constantly
    checking to see if there is something to do.


FAQ
---


How do I instantiate the Twisted reactor?
'''''''''''''''''''''''''''''''''''''''''

You **don't** ever need to instantiate it, instead just import it. The twisted reactor
is a `Singleton. <https://en.wikipedia.org/wiki/Singleton_pattern/>`_
This means there is only ever one instance. If an instance of it does not already exist,
then it is created at the time that it is imported.


How do I start it?
''''''''''''''''''

You can start the Twisted reactor by calling::

    reactor.run()

Before this point it will still exist, but will not act.

Similarly, you can stop the reactor by calling::

    reactor.stop()

Which will shut the reactor down. Once it is shut down, it will no longer be
processing functions, so restarting it programmatically from inside will be impossible.


Is there more than one implementation of the Twisted reactor?
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Yes, there are multiple implementations of the Twisted reactor that
you can import depending on what you require it to do.

You can find the various implementations in :code:`twisted.internet`. The filenames
follows the format \*reactor.

By default, importing reactor will import an **EPollReactor**
for Linux-based operating systems, and either **PollReactor** or **SelectReactor** for
other operating systems.
