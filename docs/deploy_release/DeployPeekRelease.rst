.. _deploy_peek_platform:

===================
Deploy Peek Release
===================

.. note:: The Windows or Debian requirements must be followed before following this guide.

This section describes how to deploy a peek platform release.

Peek is deployed into python virtual environments, a new virtual environment is created
for every deployment.

This ensures that each install is clean, has the right dependencies and there is a
rollback path (switch back to the old virtual environment).

To build your own platform release, see the following document
:ref:`package_peek_platform`.

.. _deploy_peek_platform_win:

Windows
-------

Deploy Virtual Environment
``````````````````````````

Open a PowerShell window.

----

Download the platform deploy script.
This is the only step in this section that requires the internet.

::

        $deployScript = "deploy_release_win.ps1"
        $uri = "https://bitbucket.org/synerty/synerty-peek/raw/master/scripts/win/$deployScript";
        [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls";
        Invoke-WebRequest -Uri $uri -UseBasicParsing -OutFile $deployScript;

----

Run the platform deploy script. The script will complete with a print out of where the
new environment was deployed.

Ensure you update the **$platformArchive** variable with the path to your release.

The script will deploy to :file:`C:\\Users\\peek`.

.. tip:: There are 80,000 files in the release, to speed up the extract, try these:

        *   Turn off antivirus, including the built in "Windows defender" in Win10
        *   Ensure 7zip is installed, the deploy script checks and uses this if it's
            present.

::

        $platformArchive = "C:\Users\peek\Downloads\peek_platform_win_#.#.#.zip"
        $pluginsArchive = "C:\Users\peek\Downloads\peek_plugins_win_#.#.#.zip"
        PowerShell.exe -ExecutionPolicy Bypass -File $deployScript $platformArchive $pluginsArchive

----

When the script completes, you will be prompted to update the environment.

Press **Enter** to make this reality.

Otherwise, you will be given commands to temporarily configure the environment to
use the synerty-peek virtual environment that was just deployed.

----

Now check that peek has been installed correctly, open a windows powershell prompt and
enter the following: ::

        get-command pip
        # Expect to see C:\Users\peek\synerty-peek-1.0.0\Scripts\pip.exe

        get-command python
        # Expect to see C:\Users\peek\synerty-peek-1.0.0\Scripts\python.exe

        python -c "import peek_platform; print(peek_platform.__file__)"
        # Expect to see C:\Users\peek\synerty-peek-1.0.0\lib\site-packages\peek_platform\__init__.py


.. note:: If the paths are not as expected, ensure that the
            SYSTEM environment PATH variable does not contain any paths with
            "C:\\Users\\Peek\\Python36\\" in it.

            When a command prompt is open the order of PATH is SYSTEM then USER.

----

Peek on windows can run as a service.
The following instructions are required to grant the ".\peek" user permissions to start
services (Grant "Login as Service").

#.  Run "services.msc"
#.  Find the peek logic service
#.  Open the properties of the service
#.  Goto the LogOn tab
#.  Enter the password twice and hit OK
#.  A dialog box will appear saying that the Peek users has been granted the right.

Thats it, Peek can now start services.

----

The platform is now deployed, see the admin page next.

*   :ref:`admin_configure_synerty_peek`
*   :ref:`admin_run_synerty_peek`


Linux
-----

Run all commands from a terminal window remotely via ssh.

----

Download the platform deploy script.

.. note:: This is the only step in this section that requires the internet.
    If you don't have internet access you may try this command, be sure to update the
    "servername" to the server ip address:
    :code:`scp Downloads/deploy_release_linux.sh peek@servername:/home/peek/deploy_release_linux.sh`

----

Run the platform deploy script. The script will complete with a print out of where the
new environment was deployed.

The script will deploy to :file:`/home/peek/`.

::

        communityArchive="/home/peek/Downloads/peek_community_linux_#.#.#.tar.bz2"
        enterpriseArchive="/home/peek/Downloads/peek_enterprise_linux_#.#.#.tar.bz2"
        bash deploy_release_linux.sh $communityArchive $enterpriseArchive

.. note::
    Ensure you update the **dist** variable with the path to your release.


----

Once the script has completed running you will see the message "Activate the
new environment edit ...".

This command configures the environment to use the synerty-peek virtual environment
that was just deployed.

----

The platform is now deployed, see the admin page next.

*   :ref:`admin_configure_synerty_peek`
*   :ref:`admin_run_synerty_peek`


macOS
-----

Run all commands from a terminal window remotely via ssh.

----

Download the platform deploy script.

.. note:: This is the only step in this section that requires the internet.
    If you don't have internet access you may try this command, be sure to update the
    "servername" to the server ip address:
    :code:`scp Downloads/deploy_release_macos.sh peek@servername:/Users/peek/deploy_release_macos.sh`


::

        file="deploy_release_macos.sh"
        uri="https://bitbucket.org/synerty/synerty-peek/raw/master/scripts/macos/$file"
        wget $uri


----

Run the platform deploy script. The script will complete with a print out of where the
new environment was deployed.

Ensure you update the **dist** variable with the path to your release.

The script will deploy to :file:`/Users/peek/`.

::

        communityArchive="/home/peek/Downloads/peek_community_macos_#.#.#.tar.bz2"
        enterpriseArchive="/home/peek/Downloads/peek_enterprise_macos_#.#.#.tar.bz2"
        bash deploy_release_macos.sh $communityArchive $communityArchive


----

Once the script has completed running you will see the message "Activate the
new environment edit ...".

This command configures the environment to use the synerty-peek virtual environment
that was just deployed.

----

The platform is now deployed, see the admin page next.

*   :ref:`admin_configure_synerty_peek`
*   :ref:`admin_run_synerty_peek`


Development Considerations
--------------------------

Deploying an new platform will clear out some of the setup for developing plugins or
the platform.

If you've run these commands as part of any development setups, you'll need to run
them again now

----

Example, run this for each python package/plugin you're developing. ::

        python setup.py develop


What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
