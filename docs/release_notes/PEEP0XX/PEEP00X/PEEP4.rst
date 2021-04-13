.. _peep4_overview:

==============
PEEP4 Overview
==============

Motivation
----------

The names of Peek plugins were often confusing, as the old “:code:`peek_mobile`” repository was intended for use in the
field, but it can run on either a mobile device or a truck mounted laptop. Therefore, we opted to call this
:code:`peek_field`. :code:`peek_field` is a WebApp, to make this clearer, the new name is :code:`peek_field_app`.

PEEP4: Rename Peek Code for v3, Field, Office, App, etc
-------------------------------------------------------

Significant renaming took place internally as a result of PEEP4.
The old and new naming conventions are listed in the following table:

.. list-table:: Web/Native
   :widths: 25 25 50
   :header-rows: 1

   * - v2 Name
     - V3 Name
     - Reason

   * - peek-desktop
     - peek-office-app
     - This app is intended for use by office staff, this app is desktop and mobile friendly.

   * - peek-mobile
     - peek-field-app
     - This app is intended for use by field staff, this app is desktop and mobile friendly.

   * - peek-admin
     - peek-admin-app
     - Adding “app” clearly identifies this component as an App.


.. list-table:: Documentation Projects
   :widths: 25 25 50
   :header-rows: 1

   * - v2 Name
     - V3 Name
     - Reason

   * - peek-doc-user
     - peek-field-doc
     - Renaming this makes it sit next to the web app.
       People looking at the app will see the doc project as well.

   * - peek-
     - peek-office-doc
     - Field and Office could not share a documentation project,
       they both try to build it and one fails to start.

   * - peek-doc-admin
     - peek-admin-doc
     - API documentation doesn't fit in anywhere, it might as well live with the admin documentation.


.. list-table:: Python Services
   :widths: 25 25 50
   :header-rows: 1

   * - v2 Name
     - V3 Name
     - Reason

   * - peek-server
     - peek-logic-service
     - Logic is a less ambiguous name.

   * - peek-worker
     - peek-worker-service
     - Adding “service” clearly identifies this component as a service.

   * - peek-agent
     - peek-agent-service
     - Adding “service” clearly identifies this component as a service.

   * - peek-storage
     - peek-storage-service
     - Adding “service” clearly identifies this component as a service.

   * - peek-client
     - peek-field-service, peek-office-service
     - For security reasons, we’ve decided to separate the backend services for Field and Office.
       In v2, there was limited support for specifying which app a plugin responds to. In v3, plugins can choose which
       service to run on.


.. list-table:: Core Plugins
   :widths: 25 25 50
   :header-rows: 1

   * - v2 Name
     - V3 Name
     - Reason

   * - peek-plugin-docdb
     - peek-core-docdb
     - The DocDB is required by the peek-core-search plugin, which means it also has to be a core plugin.


.. list-table:: Plugins
   :widths: 25 25 50
   :header-rows: 1

   * - v2 Name
     - V3 Name
     - Reason

   * - ALL peek-plugin-[pof/pon]-* plugins
     - peek-plugin-enmac-*
     - Sticking with enmac means we no longer have to manage external name changes.