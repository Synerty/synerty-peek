.. _twisted_challenges:

==================
Twisted Challenges
==================

Challenge 1: Identity Server and Client
---------------------------------------

- :download:`challenge1/question/identity_server.py`
- :download:`challenge1/question/identity_client.py`

-----

This challenge tests your knowledge on the concepts of :code:`Transport`, :code:`Protocol` and :code:`ProtocolFactory` in Twisted.

In this challenge, we have a server and a client that are based the Echo server/client in Twisted official documentation. Instead of sending the request back and forth between the peers, the server responds with a string of the client's IP and port (identity).


----

Q1: Echo Client's IP and Port as Response

-  Make proper changes to implement the following:

   -  Client Accepts user inputs from :code:`stdin` and sends the inputs with <enter> key

   -  Server responds with a message saying
      :code:`You are from <ip> on port <port>, saying "bla bla bla"`

   -  Then, server immediately loses the connection after the response

----

Q2: Display Connection History


-  Based on Q1, make further changes to implement:

   -  Record a history of IP and port of connected clients.
   -  When client sends a message :code:`show log`, respond a **minified**
      json structured as below

::

   [
       {
           "ip": "1.2.3.4",
           "port": 60000
       },
       ... ,
       ... ,
       ... ,
       {
           "ip": "1.2.3.5",
           "port": 60001
       }
   ]

----

Sample Answer:

- :download:`challenge1/answer/identity_server.py`
- :download:`challenge1/answer/identity_client.py`


Challenge 2: :code:`Deferred` 101
---------------------------------

- :download:`challenge2/question/fetch_webpage.py`

-----

This challenge tests the basics of :code:`Deferred` objects.

In this challenge, we have a simple synchronous HTTP client that needs refactoring. Your challenge is to change this code with Twisted to implement the features below.

----

Q1: Fetch the webpage

- Read function :code:`synchronousCall`

- Implement a function called :code:`chainedCall` as an asynchronous version with :code:`Deferred`

- Pass the test case :code:`testChainedCall`

----

Q2: Wrap your call chains with :code:`inlineCallbacks`

- Based on the previous question, wrap the function :code:`chainedCall` with :code:`inlineCallbacks`

- Pass the test case :code:`testInlineCallback`

----

Sample Answer:

- :download:`challenge2/answer/fetch_webpage.py`

Challenge 3: Message Relay
--------------------------

- :download:`challenge3/question/message_relay.py`

-----

This challenge tests your knowledge on chained calls with :code:`callback` and :code:`errBack`.

In this challenge, we have 3 persons relaying a message. Each person can either pass(callback) or blame(errback) to the next person. The behaviour of each person's pass/blame are pre-defined as functions in code.

----

Q1: Add code in function :code:`q1` below to stop Person 3 blaming

----

Q2: Make the message pass through Person 2 without Person 1 blaming

----

Sample Answer

- :download:`challenge3/answer/message_relay.py`


Challenge 4: Heartbeat
----------------------

- :download:`challenge4/question/heartbeat.py`

-----

This challenge tests your knowledge on :code:`loopingCall`.

The existing code is to send out heartbeat signal of "*" every 3 seconds to each session after connection. Note: this is not a *broadcast* which sends the "*" to all clients at the same time.

To test your heartbeat server, use :code:`netcat` or :code:`telnet`, connect to :code:`127.0.0.1` to port :code:`5000`.

----

Sample Answer

- :download:`challenge4/answer/heartbeat.py`


Challenge 5: Who Got "Yes" First
--------------------------------

- :download:`challenge5/question/who_got_it_first.py`

-----

This challenge tests your knowledge on :code:`DeferredList`, :code:`Failure` and your comprehensive applied knowledge of Twisted.

There is a web JSON API return randomly-picked answer of either yes or no. The challenge code is a client that sends 3 requests to the API.

----

Q1: Add code to function :code:`getAll` to retrieve all responses and then print the collected results with :code:`pprint` (which is provided)

----

Q2: Change code to function :code:`_filterAnswer` and function :code:`_handleUnexpectedAnswer` to get the first answer "yes" and stop waiting for all other requests. Do not interrupt if there is no answer "yes" in any response in which case :code:`(None, 0)` will be printed.

When you are making your change, please make sure the following is satisfied:

- :code:`_filterAnswer` filters out "yes" to the callback chain while it raises an :code:`UnexpectedAnswerError` to error-back chain if it's a "No".

- :code:`_handleUnexpectedAnswer` handles all failures from :code:`_filerAnswer`. It catches and stops the complaint due to :code:`UnexpectedAnswerError` and puts the :code:`Deferred` object back to callback chain. But it still raises any other types of failures.

----

Q3: Add code to function :code:`_displayUnexpectedAnswer` to print the filtered-out response(s) of "No" using :code:`print`.

----

Sample Answer

- :download:`challenge5/answer/who_got_it_first.py`

Challenge 6: Concurrency Limit
------------------------------

- :download:`challenge6/question/concurrency_limit.py`

-----

This challenge tests your knowledge on :code:`DeferredSemaphore`.

There is a script that gets the file sizes of gcc releases. Please add code function :code:`download` to limit concurrent requests sent by Deferred objects by :code:`maxRun`.

----

Sample Answer

- :download:`challenge6/answer/concurrency_limit.py`

Challenge 7: Cancel on Timeout
-------------------------------

- :download:`challenge7/question/cancel_on_timeout.py`

-----

This challenge tests your knowledge on cancellation and timeout.

The existing code needs a line of code to set a timeout of 2 seconds before cancel the deferred if timeout is reached. On timeout, please use :code:`logTimeout` when it is timed out.

----

Sample Answer

- :download:`challenge7/answer/cancel_on_timeout.py`

Challenge 8: Chain Them Up
--------------------------

- :download:`challenge8/question/original.py`

-----

This challenge tests your knowledge on chaining deferreds.

The original code implements a callback chain. Please refactor the two lines of :code:`addCallbacks` as an oneliner with :code:`chainDeferred`.

----

Sample Answer

- :download:`challenge8/answer/refactored.py`

Challenge 9: Work with Synchronous Functions
--------------------------------------------

- :download:`challenge9/question/original.py`

-----

This challenge tests your knowledge on integrating synchronous functions.

The original code implements a :code:`Deferred` object from a function. please reactor the function to return a Deffered.

----

Sample Answer

- :download:`challenge9/answer/refactored.py`
