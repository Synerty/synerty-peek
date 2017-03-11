=======================
Troubleshooting Windows
=======================

Device or resource busy
-----------------------

The Problem
```````````

Message received when running peek client.
::

    ln: failed to create symbolic link './node_modules': Device or resource busy

The Fix
```````

Remove and re-install the client front end packages and recreate the symlink.
::

    rm -rf peek-client-fe/peek_client_fe/node_module
    cd peek-client-fe/peek_client_fe
    npm install
    cd ../../
    ln -s peek-client-fe/peek_client_fe/node_module .

PermissionError: [WinError 5] Access is denied
----------------------------------------------

The Problem
```````````

This issue is caused when copied from another system and the symlinks need to be
recreated.
::

    Traceback (most recent call last):
      File "run_peek_server.py", line 122, in <module>
        main()
      File "run_peek_server.py", line 98, in main
        PeekPlatformConfig.pluginLoader.loadAllPlugins()
      File "C:\Users\peek\Python35\lib\site-packages\peek_server\plugin\ServerPlugin
    Loader.py", line 44, in loadAllPlugins
        self.buildFrontend()
      File "C:\Users\peek\Python35\lib\site-packages\peek_platform\plugin\PluginFron
    tendInstallerABC.py", line 105, in buildFrontend
        self._syncPluginFiles(feAppDir, pluginDetails)
      File "C:\Users\peek\Python35\lib\site-packages\peek_platform\plugin\PluginFron
    tendInstallerABC.py", line 257, in _syncPluginFiles
        os.remove(path)
    PermissionError: [WinError 5] Access is denied: 'C:\\Users\\peek\\Python35\\lib\
    \site-packages\\peek_server_fe\\src\\app\\peek_plugin_action_to_client'

The fix
```````

Remove the symlinks.  Running the modules recreates the symlinks.
::

    rm -r src/app/peek_plugin* node_modules/peek_plugin*
