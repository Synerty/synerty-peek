.. _build_capacitor_app:

===================
Build Capacitor App
===================

Build iOS App
-------------

Capacitor iOS apps can be built either via the xcode interface, or by using the xcodebuild cli.
This document will cover building the app using the xcodebuild cli.

::

    # Build iOS archive
    xcodebuild -workspace App.xcworkspace -scheme App archive -archivePath build/peek.xcarchive

    # Create iOS app from archive
    xcodebuild -exportArchive -archivePath build/peek.xcarchive -exportPath release/Peek -exportOptionsPlist OptionsPlist.plist


Build Android App
-----------------

** ToDo **

What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
