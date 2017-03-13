.. image:: https://readthedocs.org/projects/synerty-peek/badge/?version=latest
    :target: http://synerty-peek.readthedocs.io/en/latest/?badge=latest
    :alt: Documentation Status

=======
Read Me
=======

synerty-peek
------------

A multiteared architecture platform for python, supporting :

*   Plugins

*   Reactive / observable data transport

*   Multiprocessing worker services

*   Angular + Typescript frontend for:

    *   Web

    *   Nativescript

*   MS SQLServer + Windows

*   PostGreSQL + Debian Linux

This is the meta package that installs the platform.

.. NOTE:: If you don't want to install the whole platform, you can install just the
    service you want.

Services
--------

*  peek_server
*  peek_worker
*  peek_agent
*  peek_client

Browser Support
---------------

synerty-peek has only been tested on Chrome.

Future Browser Support
``````````````````````

*  Safari on iOS
*  Chrome on Android
*  Chrome desktop
*  IE 11 and above.

Installing the Platform
-----------------------

The Peek Plaform needs different requirements installed depending on the supported
platform chosen.

----

For Windows installation, follow the *Windows Requirements Install Guide*
(RequirementsWindows.rst).

For Debian installation, follow the *Debian Requirements Install Guide*
(RequirementsDebian.rst).

----

After following the Requirements Install Guide go to the *Peek Platform - Production
Setup* (ProductionSetup.rst) to install the peek services.

.. NOTE:: Should you wish to develop the peek platform it's self, run through the
    *Platform Development Setup* (PlatformDevelopmentSetup.rst) instructions instead of
    *Peek Platform - Production Setup*

----

The Peek Platform is now ready to install the required plugins.

For Plugin Development, follow the *Plugin Development Setup*
(PluginDevelopmentSetup.rst) instructions.
