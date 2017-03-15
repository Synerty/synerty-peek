=================
Peek Architecture
=================

Overview
--------

Peek has a semi distributed architecture.

This allows distribution and firewalling of the different functions of the platform.

For example, if you want to provide a means of integrating with external, less secure
systems, you can place a "Peek Agent Service" in a DMS to interface with the less secure
networks.

This achieves an extra step of separation, and potentially more processing
power.

The following diagram describes the architecture of the platform and the services it
it provides.

.. image:: platform_architecture.png

The