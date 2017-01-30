===============
Troubleshooting
===============

Device or resource busy
-----------------------

The Problem
```````````

Brenton Ford [20:01]
`ln: failed to create symbolic link './node_modules': Device or resource busy` now I keep getting this message.  It created the symlink fine before.  I’ve tried turning it off and on again

The Fix
```````

Brenton Ford [20:19]
`rm -rf peek-client-fe/peek_client_fe/node_module`, `cd peek-client-fe/peek_client_fe`, `npm install`, `cd ../../`, `ln -s peek-client-fe/peek_client_fe/node_module .` (edited)


PermissionError: [WinError 5] Access is denied
----------------------------------------------

The Problem
```````````
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
        self._relinkPluginDirs(feAppDir, pluginDetails)
      File "C:\Users\peek\Python35\lib\site-packages\peek_platform\plugin\PluginFron
    tendInstallerABC.py", line 257, in _relinkPluginDirs
        os.remove(path)
    PermissionError: [WinError 5] Access is denied: 'C:\\Users\\peek\\Python35\\lib\
    \site-packages\\peek_server_fe\\src\\app\\peek_plugin_action_to_client'

The issue is when copied from another system the symlinks need to be recreated.

The fix
```````
::

    rm -r src/app/peek_plugin* node_modules/peek_plugin*
