====================
Debian Android Setup
====================

Install the 32bit requirements
------------------------------

::

    sudo dpkg --add-architecture i386
    sudo apt-get update
    sudo apt-get install ia32-libs lib32ncurses5 lib32stdc++6 lib32z1
    sudo apt-get build-essential


Install Java JDK
----------------

::

    sudo apt-get install openjdk-8-jdk
    sudo update-alternatives --config java


Installing the SDK
------------------

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
---------------------------------

::

    $ANDROID_HOME/tools/android avd

#.  Tools -> SDK Manager

#.  Install packages as per
    .. image:: ./install_images.png

#.  Create Device as per
    .. image:: ./create_device.png


