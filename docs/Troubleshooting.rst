===============
Troubleshooting
===============

Device or resource busy
```````````````````````

Brenton Ford [20:01]
`ln: failed to create symbolic link './node_modules': Device or resource busy` now I keep getting this message.  It created the symlink fine before.  I’ve tried turning it off and on again

Brenton Ford [20:19]
the solution `rm -rf peek-client-fe/peek_client_fe/node_module`, `cd peek-client-fe/peek_client_fe`, `npm install`, `cd ../../`, `ln -s peek-client-fe/peek_client_fe/node_module .` (edited)

