.. _build_capacitor_app:

===================
Build Capacitor App
===================

Install Capacitor
-----------------

Capacitor can be installed via NPM.

::

    # Install capacitor
    cd peek_field_app # or peek_office_app
    npm install @capacitor/core @capacitor/cli --save

    # Initialise capacitor
    npx cap init

    # Setup iOS development
    npx cap add ios


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

Build Windows App
-----------------

** ToDo **

Further Reading
---------------

Further documentation on Capacitor can be found on their website.
https://capacitorjs.com/docs

What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
