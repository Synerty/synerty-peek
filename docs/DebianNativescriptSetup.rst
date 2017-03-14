=================================
Debian Nativescript Install Guide
=================================

**TODO** This is still the windows guide.

The Peek platform is designed to run on Linux, however, it is compatible with windows.
Please read through all of the documentation before commencing the installation
procedure.

Installation Objective
----------------------

This *Installation Guide* contains specific Windows operating system requirements for the
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

*   Java JDK
*   nativescript NPM package



Online Installation Guide
-------------------------


Java Install
````````````

** TODO **


Nativescript Package
````````````````````

This section installs the following:
    *   Nativescript command line utility (tns)
    *   Nativescript build tools
    *   Android emulator (with no images)
    *   Android SDK (With no SDKs)

----

Install the required NPM packages

Run the Command Prompt as Administrator and run the following commands: ::

        npm -g install nativescript

----

Do you want to run the setup script? ::

        Y

.. image:: nativescript/Nativescript-Install.jpg

----

Allow the script to install Chocolatey (It's mandatory for the rest of the script)

:Answer: A

----

Do you want to install the Android emulator?

:Answer: Y

----

Do you want to install HAXM (Hardware accelerated Android emulator)?:

:Answer: Y

----

.. image:: nativescript/Nativescript-InstallComplete.jpg

----

When the blue power shell windows says it's finished, close it.

Return focus to the original window, you should see

    > If you are using bash or zsh, you can enable command-line completion.
    > Do you want to enable it now? (Y/n)

Press "n", then "Enter".

----

When the script has finished: log off windows.

Login to windows as peek, Then open a command window and continue.

---

Check the installation with tns

:::

    tns doctor

.. image:: nativescript/Nativescript-tnsDoctor.jpg

.. note:: At this point you may find your self in a real life infinite loop.
    as tns doctor may ask you to run the setup script again if the setup is broken.

----

Confirm Environment Variable ANDROID_HOME ::

        C:\Users\peek\AppData\Local\Android\android-sdk

----

Confirm Environment Variable JAVA_HOME ::

        C:\Program Files\Java\jdk1.8.0_121


----

.. note:: For Offline installation, install the Node.js 7+ and NPM 3+ on a machine
    with internet access.  Package the installed nodejs files and installed modules
    'C:\Users\peek\nodejs'.  Unpackage in the same directory location on the offline
    server.
