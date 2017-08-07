.. _setup_nativescript_macos:

========================
Setup Nativescript MacOS
========================

The Peek platform is designed to run on Linux, however, it is compatible with macOS.
Please read through all of the documentation before commencing the installation
procedure.

Installation Objective
----------------------

This *Installation Guide* contains specific macOS operating system requirements for the
configuring of synerty-peek.

Dependencies
````````````

This install procedure requires software installed by the prerequisites steps.


Optional  Software
``````````````````

*   VirtualBox
*   Geny Motion

Required Software
`````````````````

Below is a list of all the required software:

*   nativescript NPM package



Installation Guide
------------------

Nativescript Package
````````````````````

This section installs the following:
    *   Nativescript command line utility (tns)
    *   Nativescript build tools
    *   Android emulator (with no images)
    *   Android SDK (With no SDKs)

----

Install the required NPM packages

Run the following command in terminal: ::

        npm i -g nativescript

----

Do you want to run the setup script?

:Answer: Y

----

Do you have Xcode installed (Xcode was installed during the OS Requirements Setup)?

:Answer: Y

----

software license agreements:

:Answer: agree

----

Allow the script to install Homebrew?

:Answer: Y

----

Allow the script to install Java SE Development Kit?

:Answer: Y

----

Allow the script to install Android SDK?

:Answer: Y

----

Allow the script to install CocoaPods?

:Answer: Y

----

Allow the script to install xcodeproj?

:Answer: Y

----

Do you want to install Android emulator??

:Answer: N

----

Check the installation with tns ::

        tns doctor

.. note:: At this point you may find your self in a real life infinite loop.
    as tns doctor may ask you to run the setup script again if the setup is broken.

----

Confirm Environment Variable ANDROID_HOME ::

        /usr/local/Caskroom/android-sdk/3859397,26.0.1

----

Confirm Environment Variable JAVA_HOME ::

        /Library/Java/Home


Android Emulator Setup
----------------------

You can use any emulator.  Synerty has written instructions for GenyMotion.

----

Download and Install VirtualBox

:Download: `<http://download.virtualbox.org/virtualbox/5.1.26/VirtualBox-5.1.26-117224-OSX.dmg>`_

----

Install GenyMotion, all default options

:Download: `<https://www.genymotion.com/download/>`_

----

Run both GenyMotion and Virtualbox

----

In GenyMotion select the add button to create a virtual device

----

Select a device and select next

----

Update the "Virtual device name" to something shorter (easier to remember and type) and
select next

Your virtual device will be retrieved and deployed

----

With a device selected in the "Your virtual devices" list select the "Start" button

Your device emulation will start in a new window


What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
