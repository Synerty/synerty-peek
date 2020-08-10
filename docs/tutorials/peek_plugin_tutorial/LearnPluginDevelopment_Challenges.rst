.. _learn_plugin_development_challenges:

===================
Challenges
===================

This document is designed to test your knowledge about the Peek platform.

Challenge #1: Lifecycle Methods
------------

This challenge requires you to log the current time when the peek server is in its `start` lifecycle.

The following module will be required:

::

    import datetime

The output should resemble this:

::

    10-Aug-2020 10:08:44 DEBUG peek_plugin_tutorial._private.server.ServerEntryHook:2020-08-10 10:08:44.223694
    10-Aug-2020 10:08:44 DEBUG peek_plugin_tutorial._private.server.ServerEntryHook:Started

**Point of Challenge:**

To understand how to add functionality to the various lifecycle methods located in each Peek service.

----

Challenge #2: Admin Plugin Tab
------------

This challenge requires you to develop a new tab in the "Tutorial Plugins" page within the Admin Peek site.

The output should resemble this:

.. image:: Challenge2.png

**Point of Challenge:**

To understand how to add functionality to web interfaces for each Peek service.

----

Challenge #3: Client Tasks
------------

This challenge requires you to send a task to the mobile / desktop service from the admin panel.

The output should resemble this:

.. image:: Challenge3.png

**Point of Challenge:**

To understand the various components located within the admin panel, and how they interact with other Peek services.

----

Challenge #4: VortexJs Tuple Actions
------------

This challenge requires you to create an action that doubles the current int value displayed in the StringIntComponent.

The outcome should be displayed on the mobile service, and the action should be initiated by a button click.

The output should resemble this:

.. image:: Challenge4.png

**Point of Challenge:**

To understand how tuple actions work, and how they are used by the various Peek services.

----

Challenge #5: Worker Service
------------

This challenge requires you to create a task for the worker service to complete.

The task involves the worker service logging the specific number "24" every 5 seconds.
The task name should be "SpecificNumber", and it should log the time taken and the number "24" once completed.

The output should resemble this:

::

    10-Aug-2020 14:10:31 DEBUG celery.worker.request:Task accepted: peek_plugin_tutorial._private.worker.tasks.SpecificNumber.pickSpecificNumber[fc6ee8bf-1e11-4481-b84b-66cf7e4f197a] pid:82053
    10-Aug-2020 14:10:31 INFO celery.app.trace:Task peek_plugin_tutorial._private.worker.tasks.SpecificNumber.pickSpecificNumber[fc6ee8bf-1e11-4481-b84b-66cf7e4f197a] succeeded in 0.0007026020030025393s: 24

**Point of Challenge:**

To understand how the worker service and server service communicate with one another.
