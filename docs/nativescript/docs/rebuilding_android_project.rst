

#.  Delete the "android" directory under the "platforms" directory

::

    # Get the emulator name
    android list avd | grep Name

    # Wipe the data and start emulator
    # emulator -avd <Name> -wipe-data
    emulator -avd Peek_Test -wipe-data

    # RM platform
    rm -rf playform/android


