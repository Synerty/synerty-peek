.. _learn_plugin_development_frontend_preparing:

=========================
Frontend Preparing (TODO)
=========================

The Peek Platform is extensible with plugins.
Unlike with the Python code, the frontend code can't be just imported, The frontend
code in the plugins has to be combined into build directories for each service.

This document describes how Peek combines the Frontend / Angular files into build
projects.

The frontends are the Admin, Mobile and Desktop services.

*   Admin builds:

        *   Only a Web app, using @angular/cli

*   Mobile builds:

        *   A NativeScript app, using NativeScript
        *   A Web app, using @angular/cli

*   Desktop builds:

        *   An Electron app.
        *   A Web app, using @angular/cli

The platform code for combining the files for the frontends is at:
`<https://bitbucket.org/synerty/peek-platform/src/master/peek_platform/frontend/>`_

Combining Files
---------------

End User Customisations
-----------------------



::

        {
            ...
            "frontend": {
                ...
                "frontendCustomisations": "/home/peek/peek-client.home/frontendCustomisations",
            },
            ...
        }


Live Updating for Development
-----------------------------



::

        {
            ...
            "frontend": {
                ...
                "syncFilesForDebugEnabled": true,
            },
            ...
        }
