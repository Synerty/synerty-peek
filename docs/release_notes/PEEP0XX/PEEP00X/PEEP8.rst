.. _peep8_overview:

==============
PEEP8 Overview
==============

Motivation
----------

As part of the project's core value of creating a highly maintainable code base,
Synerty routinely upgrades the dependencies that Peek runs on.

PEEP8: Upgrade to Python 3.9.1, Node 14.15.3
--------------------------------------------

As part of the project's core value of creating a highly maintainable code base, Synerty routinely
upgrades the dependencies that Peek runs on.

Why update Python?
~~~~~~~~~~~~~~~~~~

Synerty will provide the Peek v3 platform to all new upgrades and customers. Python 3.6.8 is 2 years old
at this point and we don’t want to go live with a new installation and old dependencies.

Python is part of the server setup steps, it’s not deployed as part of the release, and it’s far more difficult
to roll out updates to it.

Why update Node?
~~~~~~~~~~~~~~~~

Node is less of an issue as it’s deployed with the release and it can be changed at any time.
However, we have upgraded upgrade this dependency for the Peek v3 releases.

