.. _administer_logs:

====
Logs
====

This document provides information on the Peek Platform logs.

The Peek Platform has several serices, each one of these services has their own log.

The logs are written to the :code:`peek` users home directory,
for example, the Peek Server services logfile is located at
:file:`/home/peek/peek-server.log`.

The logs are rotated when they reach 20mb, maintaining the last two old log files.

The log level for each service can be configured in the serivices :file:`config.json`
located in the services config directory
for example :file:`/home/peek/peek-server.home/config.json`.

Change the log level with this setting: ::

    "logging": {
        "level": "DEBUG"
    },

The value must match the "Level" column in this document :
`<https://docs.python.org/3.6/library/logging.html?highlight=logging#levels>`_

System Administrators should monitor the Peek logs.
Generally only :code:`WARNING` or :code:`ERROR` messages will require some concern.
