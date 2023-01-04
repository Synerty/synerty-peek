.. _overview:

========
Overview
========

Peek Platforms primary goal is to manage, run and provide services to, hundreds of
small units of code. We call these units of code plugins.

These plugins build upon each others functionality to provide a highly maintainable,
testable, and enterprise grade environment.

Plugins can publish APIs for other plugins to use, and one plugin can run across all
services in the platform if it chooses.

The Peek Platform provides low level services, such as data transport,
database access, web server, etc. It effectively just bootstraps plugins.

With the Peek Platform up and running, plugins can be added and updated by dropping zip
files onto the peek admin web page. The platform then propagates the new plugin, loads
and runs it.

Higher level functionality is added by creating plugins.

Architecture
------------

The platform is distributed across several services, these services can be run all on
one server, or distributed across different hardware and split across firewalls.

Peek supports distribution across multiple servers and network segregation.

For example, if you want to provide a means of integrating with external, less secure
systems, you can place a "Peek Agent Service" in a DMZ to interface with the less secure
networks. The Peek Agent will talk upstream to the Peek Logic Service.

The following diagram describes the architecture of the platform and the services
it provides.

.. image:: WholePlatformArchitecture.png

Services
--------

This section describes the services which peek platform provides.

We use the term "service" with the meaning "the action of helping or doing
work for someone".
Each service is it's own entity which plugins can choose to run code on.

The exception is the "storage" service. The database can be accessed from the worker
and logic services. The database upgrade scripts are run from the "logic" service.
You could consider the database server to be the storage service.

Each service has it's logical place with in the architecture. (See the architecture
diagram above)


The services are as follows:

.. csv-table:: Peek Platform Services
    :header: "Service", "Language", "Description"
    :widths: auto

    "logic service", "python", "The center of the Peek Platform, ideal for central logic."
    "storage service", "python", "This refers to support for persisting and retrieving database data."
    "field service", "python", "The field service handles field requests from 'field app'."
    "office service", "python", "The office service handles office requests from 'office app'."
    "agent service", "python", "The agent is a satellite service, integrating with external systems."
    "worker service", "python", "The worker service provides parallel processing for computational intensive tasks"
    "admin app", "typescript", "A web based admin interface for the peek platform"
    "field app", "typescript", "The user interface for web and native apps on mobile devices."
    "office app", "typescript", "The user interface for desktops"

.. note:: Where we refer to "Angular" this means Angular version 2+. Angular1 is known
            as "AngularJS"

Peek Logic Service
``````````````````

The Peek Logic Service is the central / main / core service in the peek architecture.
This is the ideal place for plugins to integrate with each other.

All other python services talk directly to this service, and only this service.

The main coordinating logic of the plugins should run on this service.


Storage Service
```````````````
The storage service is provided by a SQLAlchemy database library, supporting anywhere
from low level database API access to working with the database using a high level ORM.

Database schema versioning is handled by Alembic, allowing plugins to automatically
update their database schemas, or patch data as required.

The database access is available on the Peek Worker and Peek Logic services.


Field Service
`````````````

The Field service was introduced to handle all requests from native and web Field
Apps. Reducing the load on the Logic Service.

Multiple Field services can connect to one Logic service, improving the maximum number
of simultaneous users the platform can handle.

The Peek Field service handles all the live data, and serves all the resources to
the Peek Field App.

The live data is serialised payloads, transferred over HTTP or Websockets. This is the
VortexJS library at work.

The Field service buffers observable data from the Logic service. The Field service will ask the Logic service
for data once, and then notifyDeviceInfo multiple users connected to the Field service when the
data arrives. However, Plugins can implement their own logic for this if required.

The Field serves all HTTP resources to the native and web Field Apps,
this includes HTML, CSS, Javascript, images and other assets.

The following diagram gives an overview of the Field Service communications.

.. image:: FieldService.png


Field App
`````````

.. image:: FieldApp.png

The Field App provides two user interfaces, a native mobile app backed by
Capacitor + Angular, and an Angular web app.

VortexJS provides data serialisation and transport to the Peek Field service via
a websockets or HTTP connection.

VortexJS provides a method for sending actions to, and observing data from the
Peek Field service. Actions and observer data can be cached in the web/native app,
allowing it to work offline.

In web developers terminology, the Field App service is called the frontend, and
the Field service is called the backend.

The Field service codes structure allows Angular components to be reused to drive web based interfaces.
For example:

*   **my-component.ts**    (Angular component, written in Typescript)
*   **my-component.web.html**   (View for Browser HTML)


Office Service
``````````````

The Office service was introduced to handle requests from native and web Office
Apps. Reducing the load on the Logic Service.

Multiple Office services can connect to one Logic service, improving the maximum number
of simultaneous users the platform can handle.

The Peek Office service handles all the live data, and serves all the resources to
the Peek Office App.

The live data is serialised payloads, transferred over HTTP or Websockets. This is the
VortexJS library at work.

The Office service buffers observable data from the Logic service. The Office service will ask the Logic service
for data once, and then notifyDeviceInfo multiple users connected to the Office service when the
data arrives. However, Plugins can implement their own logic for this if required.

The Field serves all HTTP resources to the native and web Office Apps,
this includes HTML, CSS, Javascript, images and other assets.

The following diagram gives an overview of the Office Service communications.

.. image:: OfficeService.png

Office App
``````````

.. image:: OfficeApp.png

The Peek Office app is almost identical to the Field app, using
Electron + Angular for Native office apps and Angular for the web app.

The Office service has a different user interface, designed for desktop use.

The Office service code structure allows Angular components to be reused to drive both
electron and web based interfaces. For example :

*   **my-component.tron.html**    (View for Nativescipt XML)
*   **my-component.ts**    (Angular component, written in Typescript)
*   **my-component.web.html**   (View for Browser HTML)

Plugins can be structured to reuse code and Angular components between the Field
and Office services if they choose.

Worker Service
``````````````

The Peek Worker service provides parallel processing support for the platform using the
Celery project.

The Worker service is ideal for computationally or IO expensive operations.

The Peek Logic Service queues tasks for the Worker service to process via a rabbitmq messaging
queue, the tasks are performed and the results are returned to the Peek Service via redis.

Tasks are run in forks, meaning there is one task per an operating system process, which
achives better performance.

Multiple Peek Worker services can connect to one Peek Logic Service.

Agent Service
`````````````
The Peek Agent service provides support for integrations with external system.

The Agent allows Peek to connect to other systems. There is nothing special about the
agent implementation, it's primary purpose is to separate external system integrations
from the Peek Logic service.

Peek Agent can be placed in other networks, allowing greater separation and security from
Peek Logic.

Here are some example use cases :

*   Quering and opdate Oracle databases.
*   Providing and connecting to SOAP services
*   Providing HTTP REST interfaces
*   Interfacing with other systems via SSH.

Admin App
`````````
The Peek Admin app is the Peek Administrator user interface, providing administration
for plugins and the platform.

The Peek Admin App is almost identical to the Field and Office Apps, however it only has
the web app.

The Peek Admin service is an Angular web app.

Plugins
-------

The Peek Platform doesn't do much by itself. It starts, makes all it's connections,
initialises databases and then just waits.

The magic happens in the plugins, plugins provide useful functionality to Peek.

A plugin is a single, small project focuses on providing one feature.

Enterprise Extensible
`````````````````````

The peek platform provides support for plugins to share the APIs with other plugins.

This means we can build functionality into the platform, by writing plugins.
For example, here are two publicly release plugins for Peek that add functionality :

    * Active Task Plugin - Allowing plugins to notifyDeviceInfo mobile device users
    * User Plugin - Providing simple user directory and authentication.

The "Active Task plugin" requires the "User Plugin".

Plugins can integrate with other plugins in the following services:

.. csv-table:: Peek Plugin Integration Support
    :header: "Service", "Plugin APIs"
    :widths: auto


    "logic service", "YES"
    "storage service", "no"
    "field service", "YES"
    "office service", "YES"
    "agent service", "YES"
    "worker service", "no"
    "admin app", "YES"
    "field app", "YES"
    "office app", "YES"


You could create other "User Plugins" with the same exposed plugin API for different
backends, and the "Active Task" plugin wouldn't know the difference.

Stable, exposed APIs make building enterprise applications more manageable.

The next diagram provides an example of how plugins can integrate to each other.

Here are some things of interest :

*   The SOAP plugin is implemented to talk specifically to system 1. It handles the burden
    of implementing the system 1 SOAP interface.

*   The SOAP, User and Active Task plugins provide APIs on the logic service that can
    be multiple feature plugins.

*   A feature plugin is just a name we've given to the plugin that provides features to
    the user. It's no different to any other plugin other than what it does.

.. image:: PluginIntegration.png

One Plugin, One Package
```````````````````````

All of the code for one plugin exists within a single python package. This one package
is installed on all of the services, even though only part of the plugin will run on each
service.

There are multiple entry hooks with in the plugin, one for each peek service
the plugin chooses to run on.

Each service will start a piece of the plugin, for example: Part of the plugin may run
on the logic service, and part of the plugin may run on the agent service.

Here are some plugin examples, indicating the services each platform has been designed to
run on. Here are some things of interest :

*   The User and Active Task plugins don't require the agent or worker services, so they
    don't have implementation for them.

*   All plugins have implementation for the logic service, this is an ideal place for
    plugins to integrate with each other.

.. image:: PluginArchitecture.png


This diagram illustrates how the plugins will run on the logic service.

Each plugins python package is fully installed in the logic services environment.
Plugins have entry points for the logic service.
The logic service calls this logic service entry hook when it loads each plugin.

.. image:: PluginsRunningOnLogicService.png

There are only two plugins that require the agent service, so the agent will only load
these two. Again, the whole plugin is installed in the agents python environment.

.. image:: PluginsRunningOnAgentService.png

There are three plugins that require the Office Service, so the Office service will only load
these three. Again, the whole plugin is installed in the Office Service python environment.

The field, office, agent, worker and logic services can and run from the one python
environment. This is the standard setup for single-server environments.

.. image:: PluginsRunningOnFieldService.png

There are three plugins that require the Field App. The Field App is a python
package that contains the build skeletons for the web app.

The Field App combines (copies) the files required from each of the plugins into the
build environments, and then compiles the web app.

The Field and Logic services
prepare and compile the Field and Admin apps, as these are all HTML, SCSS and
Typescript.

The office/field, and admin interfaces need the office/field, and logic python services to
run, so this compile arrangement makes sense.

.. image:: PluginsRunningOnFieldApp.png

.. _overview_noop_plugin_example:

Noop Plugin Example
-------------------

The NOOP plugin is a testing / example plugin.

It's designed to test the basic operations of the platform and runs on every service.
All of the code for the plugin is within one python packaged, named "peek-plugin-noop".

.. image:: OverviewNoopPlugin.png

The code is available here:
`Peek Plugin Noop, on bitbucket <https://bitbucket.org/synerty/peek-plugin-noop>`_,
It's folder structure looks like this :

*   :file:`peek-plugin-noop` (Root project dir, pypi package name)

    *   :file:`peek_plugin_noop` (The plugin root, this is the python package)

        *   :file:`_private` (All protected code lives in here)
            See subfolders below.

        *   :file:`plugin-modules`   (Exposed API, index.ts will expose public declarations.
            Plugins can structure the subfolders however they like, this dir is available
            from node_modules/@peek/peek_plugin_noop)
            See subfolders below.

---

An example contents of the :file:`_private` is described below.

*   :file:`_private` (All protected code lives in here)

    *   :file:`admin-app`   (The admin web based user interface)

    *   :file:`admin-assets`   (Static assets for the admin web UI)

    *   :file:`agent-service` (The code that runs on the agent service)

    *   :file:`alembic` (Database schema versioning scripts)

    *   :file:`field-service`  (The code that runs on the field service)

    *   :file:`office-service`  (The code that runs on the office service)

    *   :file:`office-app`   (The office user interface that runs natively and on the mobile/web devices)

    *   :file:`office-assets`    (Images for the desktop/web)

    *   :file:`field-app`   (The field user interface that runs natively and on the mobile/web devices)

    *   :file:`field-assets`    (Images for the mobile/web UI)

    *   :file:`logic-service`  (The code that runs on the logic service)

    *   :file:`storage-service` (SQLAlchemy ORM classes for db access, used by logic and worker)

    *   :file:`tuples`  (Private data structures)

    *   :file:`worker-service`  (The parallel processing  Celery tasks that are run on the worker)

---

An example contents of the :file:`plugin-modules` is described below.

*   :file:`plugin-modules`   (Exposed API, index.ts will expose public declarations.
    Plugins can structure the subfolders however they like, this dir is available
    from node_modules/@peek/peek_plugin_noop)

    *   :file:`office-app`   (Exposed API, index.ts exposes office only declarations)

    *   :file:`field-app`   (Exposed API, index.ts exposes field only declarations)

    *   :file:`admin-app`   (Exposed API, index.ts exposes admin only declarations)

    *   :file:`_private`   (Code only used by this plugin)

        *   :file:`office-app`   (Private office declarations)

        *   :file:`field-app`   (Private field declarations)

        *   :file:`admin-app`   (Private admin declarations)

*   :file:`agent-app`  (Exposed API, plugins on the agent service use this)

*   :file:`field-service`  (Exposed API, plugins on the field service use this)

*   :file:`office-service`  (Exposed API, plugins on the office service use this)

*   :file:`logic-service`  (Exposed API, plugins on the logic service use this)

*   :file:`tuples`  (Exposed Tuples, Tuples on any service use these data structures)

---

.. note:: Random Fact : Did you know that python can't import packages with hyphens in them?

