=========================
Windows Development Setup
=========================

.. WARNING:: This document extends, Windows Requirements Install Guide
(RequirementsWindows.rst).


.. NOTE:: Most development will be for the plugins, not platform, so these instructions
    are not high priority.


Hardware Recommendation
-----------------------

*  32gb of ram (minimum 16gb)

Software Requirements
---------------------

Follow these steps using the Cygwin terminal.

Enable your device for development
``````````````````````````````````

.. image:: windows_development_setup_screenshots/DevMode-UpdateSecurity.jpg
.. image:: windows_development_setup_screenshots/DevMode-ForDevelopers.jpg
`<https://msdn.microsoft.com/en-us/windows/uwp/get-started/enable-your-device-for-development>`_

Clone Peek Repositories
-----------------------

#.  Checkout the following, all in the same folder,

    .. NOTE:: core.symlink:  If false, symbolic links are checked out as small plain
    files that contain the link text. git-update-index[1] and git-add[1] will not change
    the recorded type to regular file. Useful on filesystems like FAT that do not support
    symbolic links.  The default is true, except git-clone[1] or git-init[1] will probe
    and set core .symlinks false if appropriate when the repository is created.

    :From: `<https://github.com/Synerty>`_

    *  Repositories
        *.  synerty-peek
        *.  peek-plugin-base
        *.  peek-agent
        *.  peek-client
        *.  peek-client-fe
        *.  peek-platform
        *.  peek-server
        *.  peek-server-fe
        *.  peek-worker
    ::

            cd ~peek/Documents/
            mkdir peek-mobile
            cd ~peek/Documents/peek-mobile/
            git clone https://github.com/Synerty/{repository}.git
            cd ~peek/Documents/peek-mobile/{repository}
            git config --unset core.symlink
            git config --add core.symlink true

    *  Script to clone all repositories: ::

			repo1='synerty-peek'
			repo2='peek-plugin-base'
			repo3='peek-agent'
			repo4='peek-client'
			repo5='peek-client-fe'
			repo6='peek-platform'
			repo7='peek-server'
			repo8='peek-server-fe'
			repo9='peek-worker'
			repo10='none'

			declare -a repos=($repo1 $repo2 $repo3 $repo4 $repo5 $repo6 $repo7 $repo8 $repo9 $repo10)
			cd ~peek/Documents/
			mkdir ~peek/Documents/peek-mobile
			for repo in ${repos[@]}:
			do
				echo $repo
				cd ~peek/Documents/peek-mobile/
				git clone https://github.com/Synerty/$repo.git
				cd ~peek/Documents/peek-mobile/$repo
				git config --unset core.symlink
				git config --add core.symlink true
			done
			cd ~peek/Documents/peek-mobile/
			ls -l

#.  Install front end modules

    Remove the old npm modules files and re-install for both client and server front
    and packages.  Run the following commands: ::

            cd ~peek/Documents/peek-mobile/peek-client-fe/peek_client_fe/
            [ -d node_modules ] && rm -rf node_modules
            npm install
            cd ~peek/Documents/peek-mobile/peek-server-fe/peek_server_fe/
            [ -d node_modules ] && rm -rf node_modules
            npm install

#.  Symlink the tsconfig.json and node_modules file and directory in the parent
directory of peek-client-fe, peek-server-fe and the plugins. These steps are run in the
directory where the projects are checked out from. These are required for the frontend
typescript compiler. ::

        cd ~peek/Documents/peek-mobile/
        ln -s peek-client-fe/peek_client_fe/node_modules .
        ln -s peek-client-fe/peek_client_fe/tsconfig.json .

        cd ~peek/Documents/peek-mobile/peek-client-fe/peek_client_fe/
        ng build
        cd ~peek/Documents/peek-mobile/peek-server-fe/peek_server_fe/
        ng build

#.  These steps link the projects under site-packages and installs their dependencies.

    #.  Run the following commands ::

            cd ~peek/Documents/peek-mobile/synerty-peek
            ./pip_uninstall_and_develop.sh

    #.  For repositories and plugins run from their directory ::

            $ python setup.py develop


#.  Test cx_Oracle with Alchemy (after installing peek) ::

        >>>
        >>> from sqlalchemy import create_engine

        >>> create_engine('oracle://username:password@hostname:1521/instance')
        >>> engine = create_engine('oracle://enmac:bford@192.168.215.128:1521/enmac')
        >>> engine.execute("SELECT 1")

*You can now start developing*
