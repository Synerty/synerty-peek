========
Overview
========

Architecture
------------

Peek has a semi distributed architecture.

There are multiple services in the Peek Platform, these are :

*   Server
*   Storage
*   Client
*   Worker
*   Agent

This allows distribution across multiple servers and network segregation.

For example, if you want to provide a means of integrating with external, less secure
systems, you can place a "Peek Agent Service" in a DMZ to interface with the less secure
networks.

This achieves an extra step of separation, and potentially more processing
power.

The following diagram describes the architecture of the platform and the services it
it provides.

.. image:: platform_architecture.png

Services
--------

This section describes the services of the Peek Platform.

Server Service
``````````````

The server service is the central / main / core server in the peek architecture.

All other services talk directly to this service, and only this service.

The main cordinating loging of the plugins should run on this service.


Storage Service
```````````````


Client Service
``````````````

Worker Service
``````````````

Agent Service
`````````````

Plugins
-------

A plugin is a single, small project focuses on providing one feature.

There are muliple entry hooks with in the plugin, one for each peek service
the plugin chooses to run on.

Each service will start a peice of the plugin, for example : Part of the plugin may run
on the server service, and part of the plugin may run on the agent service.

