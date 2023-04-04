.. _ssl.config_json:

====================
Configure Mutual TLS
====================

To configure the Logic Service for mutual TLS:


#. In the config.json file, locate the section **httpServer-> dataExchange**.

#. Update :code:`sslBundleFilePath` with the file path to the
   :code:`peek_bundle.pem` file.

#. Update :code:`sslMutualTLSCertificateAuthorityBundleFilePath` with the file
   path to the :code:`peek_mtls_ca_bundle.pem` file.

#. Update :code:`sslMutualTLSTrustedPeerCertificateBundleFilePath` with the
   file path to the :code:`peek_mtls_trusted_peer_bundle.pem` file.

#. Update :code:`sslEnableMutualTLS` to :code:`true`

#. Update :code:`useSsl` to :code:`true`

::

    "httpServer": {
        ...
        ...
        ...
        "dataExchange": {
            "sitePort": 8011,
            "sslBundleFilePath": "/tmp/self-signed/peek_bundle.pem",
            "sslEnableMutualTLS": true,
            "sslMutualTLSCertificateAuthorityBundleFilePath": "/tmp/self-signed/peek_mtls_ca_bundle.pem",
            "sslMutualTLSTrustedPeerCertificateBundleFilePath": "/tmp/self-signed/peek_mtls_trusted_peer_bundle.pem",
            "useSsl": true
        }
    }

----

Configure the Mutual TLS on the Peek Services, update the Peek
Agent, Field, Office, and Worker services :code:`.json` files with the
following:

#. In the configuration file, locate the :code:`dataExchange` section.

#. Update :code:`host` with the domain name of Peek Logic which matches
   pattern \*.peek.local TODO

#. Ensure the DNS service on current mutual TLS client resolves the domain name
   in host to the IP of Peek Logic server.

#. Update :code:`sslClientBundleFilePath` with the file path to the
   :code:`peek_bundle.pem` file.

#. Update :code:`sslClientMutualTLSCertificateAuthorityBundleFilePath` with the
   file path to the :code:`peek_mtls_ca_bundle.pem` file.

#. Update :code:`sslMutualTLSTrustedPeerCertificateBundleFilePath` with the
   file path to the :code:`peek_mtls_trusted_peer_bundle.pem` file.

#. Update :code:`sslEnableMutualTLS` to :code:`true` .

#. Update :code:`useSsl` to :code:`true`

::

        "dataExchange": {
            "host": "[hostname]",
            "httpPort": 8011,
            "sslClientBundleFilePath": "[full path to peek_bundle.pem]",
            "sslClientMutualTLSCertificateAuthorityBundleFilePath":"[full path to peek_mtls_ca_bundle.pem]",
            "sslEnableMutualTLS": true,
            "sslMutualTLSTrustedPeerCertificateBundleFilePath": "[peek_mtls_trusted_peer_bundle.pem]",
            "useSsl": false
        },

----

Restart the Peek Services. ::

        p_restart.sh

Complete
--------