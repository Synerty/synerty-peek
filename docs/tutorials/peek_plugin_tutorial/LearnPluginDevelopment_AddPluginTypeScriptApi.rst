.. _learn_plugin_development_add_plugin_typescript_apis:

=================================
Add Plugin TypeScript APIs (TODO)
=================================

Overview
--------

This document will describe how to use the APIs between plugins running on the:

*   Field
*   Office
*   and Admin services

These services all run TypeScript + Angular, the integrations are provided by the
standard Angular services mechanisms.

How To
------

For a plugin to publish an API, Create an Angular Service.

For a plugin to use another plugins API, Use that service in the constructor of your
Angular service, component or module.

.. warning:: Be careful with singleton services, adding it to multiple provides will
                cause the service to be created again instead of looking for a provider
                in the parent.

That's basically how this will work. Examples to come at a later date.
