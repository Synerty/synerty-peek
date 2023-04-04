.. _configure_ssl:

================================
Install Self Signed Certificates
================================

Follow this tutorial for the installation of self signed certificates on a
Peek server. This can be done for the Web Frontend services or for mutual TLS
between Peek services.


Create the Certificates
-----------------------

Log into the server using SSH as the Peek user.

----

Run the following commands: ::

        mkdir ~/cert

        cd ~/cert

        wget -O generate_self_signed_certificates.py \
        'https://gitlab.synerty.com/peek/community/synerty-peek/-/raw/bad53f383053c88a731334894857d48295859618/scripts/linux/util/generate_self_signed_certificates.py?inline=false'

        python generate_self_signed_certificates.py

----

Insure you have three :code:`.pem` files in the :code:`~/cert` directory.

.. note:: :code:`peek_bundle.pem` contains a private key, certificate and CA
    certificate. The certificate is wild-card certificate that matches by
    pattern.

Update Service Configuration Files
----------------------------------

To use the certificates for Peek frontend servers, edit the
:code:`~/peek-{admin,field,office}-service.home/config.json` files:

#. Update the :code:`sslBundleFilePath` with the file path to the
   :code:`peek_bundle.pem` file.
#. Update the :code:`"useSsl"` to :code:`true`

::

        "httpServer": {
              "admin/field/office": {
                    ...
                    ...
                    "sslBundleFilePath": "[path to peek_bundle\_.pen]",
                    "useSsl": true
              }

----

Restart the Peek Services. ::

        p_restart.sh



Complete
--------

You have successfully configured Peek to use self-signed certificates.



