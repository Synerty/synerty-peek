============================
Using the Deferred Semaphore
============================

Twisted's **DeferredSemaphore** object allows the user to  limit the number of
Deferred's that can be created at once.


When to use it
--------------

You may be wondering why you would want to impose a limit on asynchronous behavior.
After all, the ability to do multiple things seemingly at once is the major draw of
asynchronous computing. Consider the following scenario:

Imagine an asynchronous platform needs to send out a large backlog of emails once
per day. We know that as soon as Twisted's reactor starts, it will begin firing
each deferred that is ready in the order it receives them.

If the list of emails to send is particularly large, it could be attempting to send
hundreds or thousands at once.
`This could quickly become too much for the server to handle.
<https://en.wikipedia.org/wiki/Denial-of-service_attack>`_

The **Deferred Semaphore** is perfect for situations where we need to limit the number
of Deferreds being processed while dealing with a large backlog of work.

`These are used <https://gitlab.synerty.com/peek/peek-plugin-diagram/-/blob/master/
peek_plugin_diagram/_private/server/controller/LookupImportController.py#L36>`_
in `Peek. <https://gitlab.synerty.com/peek/peek-abstract-chunked-index/-/blob/master/
peek_abstract_chunked_index/private/server/controller/
ACIProcessorQueueControllerABC.py#L69>`_


How to use it
-------------

The below code takes a list of items to process that will return Deferreds.
To help it manage the amount of resources it dedicates to processing a potentially
endless list, it creates a :code:`DeferredSemaphore`, 'sem'.

This :code:`DeferredSemaphore` runs the list of items to process for us and
keeps track of which Deferreds it has created. The :code:`DeferredSemaphore` will only
create up to :code:`maxRun` Deferreds at once, and then it will wait until one of it's
Deferreds have fired before continuing::

    from twisted.internet import defer
    from twisted.trial import unittest


    class ExampleTest(unittest.TestCase):

        def testProcessWithSemaphore(self):
            # Setup variables
            maxRun = 2
            taskList = [1, 2, 3, 4, 5, 6]
            deferrals = []

            # Have a Semaphore run functions
            # and create Deferreds in a controlled manner
            sem = defer.DeferredSemaphore(maxRun)
            for task in taskList:
                d = sem.run(print, task)
                deferrals.append(d)

            # (Use a Deferredlist to await all callbacks)
            dList = defer.DeferredList(deferrals)
            dList.addCallback(print)

            return dList

----

Which should output something like::

    1

    Ran 1 test in 0.103s

    OK
    2
    3
    4
    5
    6
    [(True, None), (True, None), (True, None), (True, None), (True, None), (True, None)]


