=============
Peek Platform
=============

A platform for python written for Twisted.

This is the meta package that installs the platform.

If you don't want to install the whole platform, you can install just the service you want

#.  peek_server
#.  peek_worker
#.  peek_agent
#.  peek_client


DEVELOPING
----------

For platform development (NOTE: Most development will be for the papp, not platform, so these instructions are not high priority)
.#      Checkout the following, all in the same folder
    .#  peek
    .#  papp_base
    .#  peek_agent
    .#  peek_client
    .#  peek_client_fe
    .#  peek_platform
    .#  peek_server
    .#  peek_server_fe
    .#   peek_worker
.#  Open pycharm,
    .#  open the peek project, open in new window
    .#  Open each of the other projects mentioned above, add to current window
.# File -> Settings (Ctrl+Alt+S with eclipse keymap)
    .# Editor -> Inspection
        .# Disable Python -> "PEP8 Naming Convention Violation" (use search bar)
        .# Change Python -> "Type Checker" from warning to error (use search bar)
    .# Project -> Project Dependencies
        .#  peek_platform depends on -> papp_base
        .#  peek_server depends on -> peek_platform, peek_server_fe
        .#  peek_client depends on -> peek_platform, peek_client_fe
        .#  peek_agent depends on -> peek_platform
        .#  peek_worker depends on -> peek_platform

