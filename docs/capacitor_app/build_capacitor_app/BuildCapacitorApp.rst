.. _build_capacitor_app:

===================
Build Capacitor App
===================

iOS
```

Capacitor iOS apps can be built either via the xcode interface, or by using the
xcodebuild cli. This document will cover building the app using the
xcodebuild cli.

Configure OptionsPlist.plist
----------------------------
The information specified in this plist  will be used by xcode for building and
exporting the app.

Download the example plist found :download:`here <OptionsPlist.plist>` to your
:code:`~/Downloads` folder and open it with xcode. Then, double click the
fields and fill them out with the relevant information.

.. image:: PlistEditing.png

Save and close :code:`OptionsPlist.plist`.

----

Set Variables
-------------

Some custom environment variables should be set before building the App

.. list-table:: Variables
   :widths: 50 50
   :header-rows: 1

   * - Variable
     - Description
   * - CLIENT
     - The name of the client the App is being built for.
   * - VERSION
     - The tagged version of the App being built.
   * - EXPORT_DIR
     - The directory to export the App to.
   * - APP_PACKAGE_ID
     - The bundle identifier used to sign this app


----

When filled out, the environment variables should look similar to the below:

::

    CLIENT="Synerty"
    VERSION="3.1.0"
    EXPORT_DIR="$HOME/Peek_builds/$CLIENT/$VERSION"
    APP_PACKAGE_ID="com.synerty.peek"


Copy and paste yours into your terminal


----

Create Necessary Directories
----------------------------
These will be used for building and exporting the app

::

    cd
    mkdir -p $EXPORT_DIR
    mkdir -p tmp_peek_build_data
    cd tmp_peek_build_data


----

Move OptionsPlist.plist into place
----------------------------------
The configured OptionsPlist file must now be moved to a directory it can be
referenced from in the build. In our case, this is
:code:`${EXPORT_DIR}/OptionsPlist.plist`

::

    mv ~/Downloads/OptionsPlist.plist ${EXPORT_DIR}/OptionsPlist.plist


----

Clone the Field App
-------------------
Clone the field app and switch to the required tag for this build:

::

    git clone https://gitlab.synerty.com/peek/community/peek-field-app.git
    cd peek-field-app/peek_field_app/
    git fetch --all --tags
    git checkout tags/$VERSION


----

Set up Capacitor
----------------

Capacitor will need to be prepared to build an iOS App. Ignore any warnings that
an ios directory already exists.

::

    npm install @capacitor/core @capacitor/cli --save
    npx cap init peek_ios_app_v${VERSION} $APP_PACKAGE_ID
    npx cap add ios


----

Install build prerequisites
---------------------------

::

    cd ios/App
    pod install
    npm i
    mkdir public

----

Prepare an App archive
----------------------

An archive is a more general build that can be used to speed up subsequent
builds with small config changes, e.g specifying new certificates.

::

    xcodebuild \
      -workspace App.xcworkspace \
      -scheme App archive \
      -archivePath ${EXPORT_DIR}/peek.xcarchive \
      -allowProvisioningUpdates


----

Build from the archive
----------------------

This is the actual build and the resulting App can be found in the :code:`EXPORT_DIR`
directory defined earlier.

::

    xcodebuild -exportArchive \
      -archivePath ${EXPORT_DIR}/peek.xcarchive \
      -exportPath ${EXPORT_DIR}/Peek \
      -exportOptionsPlist ${EXPORT_DIR}/OptionsPlist.plist


----

Clean up the Build Directory
----------------------------

The build directory can now be cleaned, as all output files, including archives,
can now be found in the :code:`EXPORT_DIR` directory defined earlier.

::

    cd
    rm -rf tmp_peek_build_data


----


Build Android App
`````````````````

** ToDo **

Build Windows App
`````````````````

** ToDo **

Further Reading
```````````````

Further documentation on Capacitor can be found on their website.
https://capacitorjs.com/docs

What Next?
``````````

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
