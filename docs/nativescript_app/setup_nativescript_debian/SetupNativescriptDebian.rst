.. _setup_nativescript_debian:

=========================
Setup Nativescript Debian
=========================

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



Installation Guide
------------------


Install the 32bit requirements
``````````````````````````````

::

    sudo dpkg --add-architecture i386
    sudo apt-get update
    sudo apt-get install ia32-libs lib32ncurses5 lib32stdc++6 lib32z1
    sudo apt-get build-essential


Install Java JDK
````````````````

::

    sudo apt-get install openjdk-8-jdk
    sudo update-alternatives --config java


Installing the SDK
``````````````````

Download the SDK only from here, scroll right to the bottom, to the
"Get just the command line tools" section, and download the linux tools.

https://developer.android.com/studio/index.html#downloads

::

    mkdir ~/android && cd ~/android
    unzip /media/psf/Downloads/tools_r25.2.3-linux.zip

    echo "export JAVA_HOME=$(update-alternatives --query javac | sed -n -e 's/Best: *\(.*\)\/bin\/javac/\1/p')" >> ~/.bashrc
    echo "export ANDROID_HOME=~/android" >> ~/.bashrc
    echo "alias android=$ANDROID_HOME/tools/android" >> ~/.bashrc
    echo "alias emulator=$ANDROID_HOME/tools/emulator" >> ~/.bashrc


Create the Android Virtual Device
`````````````````````````````````

::

    $ANDROID_HOME/tools/android avd

#.  Tools -> SDK Manager

#.  Install packages as per
    .. image:: ./install_images.png

#.  Create Device as per
    .. image:: ./create_device.png







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

###.. image:: Nativescript-Install.jpg

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

.. image DISABLED:: Nativescript-InstallComplete.jpg

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

::

    tns doctor

.. image DISABLED:: Nativescript-tnsDoctor.jpg

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

What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
