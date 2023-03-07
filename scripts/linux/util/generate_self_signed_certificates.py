#!/usr/bin/env python3


from pathlib import Path
from typing import Tuple
from typing import Union

from cryptography import x509
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives.asymmetric.rsa import RSAPrivateKey
from cryptography.hazmat.backends import default_backend
from datetime import datetime, timedelta

from cryptography.x509 import Certificate
from cryptography.x509 import CertificateSigningRequest


class X509Config:
    VALID_DAYS = 3650

    COUNTRY_NAME = "AU"
    STATE_OR_PROVINCE_NAME = "QLD"
    LOCALITY_NAME = "Brisbane"
    ORGANIZATION_NAME = "Synerty"

    def __init__(
        self,
        commonName: str = "",
        dnsNames: list[str] = [],
        organizationalUnitName="Peek",
    ):
        self.COMMON_NAME = commonName
        self.DNS_NAMES = dnsNames
        self.ORGANIZATIONAL_UNIT_NAME = organizationalUnitName


class SelfSignedCertificateGenerator:
    def __init__(
        self,
        organizationalUnitName: str,
        secondaryDomainNames: list[str],
        outputFolder: str = ".",
    ):
        self._organizationalUnitName = organizationalUnitName
        self._secondaryDomainNames = secondaryDomainNames

        self._outputFolder = outputFolder
        Path(self._outputFolder).mkdir(parents=True, exist_ok=True)

    def generate(self):

        # CA
        caPrivateKey = self.genRsaKey()

        caX509Config = X509Config(
            commonName=f"{self._organizationalUnitName.upper()} SELF-SIGNED CA"
        )
        ca = self.genCA(caPrivateKey=caPrivateKey, config=caX509Config)

        # self.dumpCertificateLikeObjectToPEM(
        #     certificateLikeObject=ca, fileName="ca.crt"
        # )

        # CSR
        csrConfig = X509Config(
            commonName=f"*.{self._organizationalUnitName.lower()}.local",
        )
        certPrivateKey, csr = self.genCSR(csrConfig)

        # self.dumpPrivateKeyToPEM(
        #     privateKey=certPrivateKey,
        #     fileName=f"{self._organizationalUnitName.lower()}.key",
        # )

        # cert - sign the csr
        certConfig = X509Config(
            dnsNames=[
                f"{name.lower()}.{self._organizationalUnitName.lower()}.local"
                for name in self._secondaryDomainNames
            ],
        )

        cert = self.genCertFromCSR(
            csr=csr, ca=ca, caPrivateKey=caPrivateKey, config=certConfig
        )

        # self.dumpCertificateLikeObjectToPEM(
        #     certificateLikeObject=cert,
        #     fileName=f"{self._organizationalUnitName.lower()}.crt",
        # )

        # bundle for web servers, mtls servers/clients
        #  i.e. privateKey + fullchain
        self.bundleForIdentity(
            key=certPrivateKey,
            cert=cert,
            ca=ca,
            fileName=f"{self._organizationalUnitName.lower()}_bundle.pem",
        )

        # bundle for mtls CA
        self.bundleForMtlsCAChain(
            ca=ca,
            fileName=f"{self._organizationalUnitName.lower()}_mtls_ca_bundle.pem",
        )

        # bundle for mtls trusted peers
        self.bundleForMtlsTrustedPeers(
            cert=cert,
            fileName=f"{self._organizationalUnitName.lower()}_mtls_trusted_peer_bundle.pem",
        )

    def bundleForIdentity(
        self,
        key: RSAPrivateKey,
        cert: Certificate,
        ca: Certificate,
        fileName: str,
    ):
        fullFilePath = Path(self._outputFolder) / Path(fileName)
        fullFilePath.unlink(missing_ok=True)

        self.dumpPrivateKeyToPEM(
            privateKey=key, fileName=fileName, isAppend=True
        )
        self.dumpCertificateLikeObjectToPEM(
            certificateLikeObject=cert, fileName=fileName, isAppend=True
        )
        self.dumpCertificateLikeObjectToPEM(
            certificateLikeObject=ca, fileName=fileName, isAppend=True
        )

    def bundleForMtlsCAChain(self, ca: Certificate, fileName: str):
        fullFilePath = Path(self._outputFolder) / Path(fileName)
        fullFilePath.unlink(missing_ok=True)

        self.dumpCertificateLikeObjectToPEM(
            certificateLikeObject=ca, fileName=fileName
        )

    def bundleForMtlsTrustedPeers(self, cert: Certificate, fileName: str):
        fullFilePath = Path(self._outputFolder) / Path(fileName)
        fullFilePath.unlink(missing_ok=True)

        self.dumpCertificateLikeObjectToPEM(
            certificateLikeObject=cert, fileName=fileName
        )

    def dumpCertificateLikeObjectToPEM(
        self,
        certificateLikeObject: Union[Certificate, CertificateSigningRequest],
        fileName: str,
        isAppend: bool = False,
    ):
        with open(
            Path(self._outputFolder) / Path(fileName),
            "ab" if isAppend else "wb",
        ) as f:
            f.write(
                certificateLikeObject.public_bytes(
                    encoding=serialization.Encoding.PEM,
                )
            )

    def dumpPrivateKeyToPEM(
        self, privateKey: RSAPrivateKey, fileName: str, isAppend: bool = False
    ):
        with open(
            Path(self._outputFolder) / Path(fileName),
            "ab" if isAppend else "wb",
        ) as f:
            f.write(
                privateKey.private_bytes(
                    encoding=serialization.Encoding.PEM,
                    format=serialization.PrivateFormat.TraditionalOpenSSL,
                    encryption_algorithm=serialization.NoEncryption(),
                )
            )

    def genRsaKey(self):
        return rsa.generate_private_key(
            public_exponent=65537, key_size=2048, backend=default_backend()
        )

    def genCA(
        self, caPrivateKey: RSAPrivateKey, config: X509Config
    ) -> Certificate:

        # Define the subject for the CA
        caSubject = x509.Name(
            [
                x509.NameAttribute(
                    x509.NameOID.COUNTRY_NAME, config.COUNTRY_NAME
                ),
                x509.NameAttribute(
                    x509.NameOID.STATE_OR_PROVINCE_NAME,
                    config.STATE_OR_PROVINCE_NAME,
                ),
                x509.NameAttribute(
                    x509.NameOID.LOCALITY_NAME, config.LOCALITY_NAME
                ),
                x509.NameAttribute(
                    x509.NameOID.ORGANIZATION_NAME, config.ORGANIZATION_NAME
                ),
                x509.NameAttribute(
                    x509.NameOID.ORGANIZATIONAL_UNIT_NAME,
                    config.ORGANIZATIONAL_UNIT_NAME,
                ),
                x509.NameAttribute(
                    x509.NameOID.COMMON_NAME, config.COMMON_NAME
                ),
            ]
        )

        # Define the validity period for the CA certificate
        caNotValidBefore = datetime.utcnow()

        # Create the CA certificate
        caCertificate = (
            x509.CertificateBuilder()
            .subject_name(caSubject)
            .issuer_name(caSubject)
            .public_key(caPrivateKey.public_key())
            .serial_number(x509.random_serial_number())
            .not_valid_before(caNotValidBefore)
            .not_valid_after(
                caNotValidBefore + timedelta(days=config.VALID_DAYS)
            )
            .add_extension(
                x509.BasicConstraints(ca=True, path_length=None), critical=True
            )
            .sign(
                private_key=caPrivateKey,
                algorithm=hashes.SHA256(),
                backend=default_backend(),
            )
        )

        return caCertificate

    def genCSR(
        self,
        config: X509Config,
    ) -> Tuple[RSAPrivateKey, CertificateSigningRequest]:
        key = self.genRsaKey()
        # Generate a CSR
        csr = (
            x509.CertificateSigningRequestBuilder().subject_name(
                x509.Name(
                    [
                        # Provide various details about who we are.
                        x509.NameAttribute(
                            x509.NameOID.COUNTRY_NAME, config.COUNTRY_NAME
                        ),
                        x509.NameAttribute(
                            x509.NameOID.STATE_OR_PROVINCE_NAME,
                            config.STATE_OR_PROVINCE_NAME,
                        ),
                        x509.NameAttribute(
                            x509.NameOID.LOCALITY_NAME, config.LOCALITY_NAME
                        ),
                        x509.NameAttribute(
                            x509.NameOID.ORGANIZATION_NAME,
                            config.ORGANIZATION_NAME,
                        ),
                        x509.NameAttribute(
                            x509.NameOID.ORGANIZATIONAL_UNIT_NAME,
                            config.ORGANIZATIONAL_UNIT_NAME,
                        ),
                        x509.NameAttribute(
                            x509.NameOID.COMMON_NAME, config.COMMON_NAME
                        ),
                    ]
                )
            )
            # Sign the CSR with our private key.
            .sign(key, hashes.SHA256())
        )

        return key, csr

    def genCertFromCSR(
        self,
        csr: CertificateSigningRequest,
        ca: Certificate,
        caPrivateKey: RSAPrivateKey,
        config: X509Config,
    ) -> Certificate:
        certBuilder = (
            x509.CertificateBuilder()
            .subject_name(csr.subject)
            .issuer_name(ca.subject)
            .public_key(csr.public_key())
            .serial_number(x509.random_serial_number())
            .not_valid_before(datetime.utcnow())
            .not_valid_after(
                datetime.utcnow() + timedelta(days=config.VALID_DAYS)
            )
            .add_extension(
                x509.BasicConstraints(ca=False, path_length=None), critical=True
            )
            .add_extension(
                x509.SubjectKeyIdentifier.from_public_key(
                    caPrivateKey.public_key()
                ),
                critical=False,
            )
            .add_extension(
                x509.KeyUsage(
                    digital_signature=True,
                    content_commitment=False,
                    key_encipherment=True,
                    data_encipherment=False,
                    key_agreement=False,
                    key_cert_sign=False,
                    crl_sign=False,
                    encipher_only=False,
                    decipher_only=False,
                ),
                critical=True,
            )
            .add_extension(
                x509.ExtendedKeyUsage(
                    usages=[
                        x509.ExtendedKeyUsageOID.SERVER_AUTH,
                        x509.ExtendedKeyUsageOID.CLIENT_AUTH,
                    ]
                ),
                critical=False,
            )
            .add_extension(
                x509.SubjectAlternativeName(
                    # Describe what sites we want this certificate for.
                    [x509.DNSName(dnsName) for dnsName in config.DNS_NAMES]
                ),
                critical=False,
            )
        )
        return certBuilder.sign(caPrivateKey, hashes.SHA256())


if __name__ == "__main__":
    g = SelfSignedCertificateGenerator(
        organizationalUnitName="Peek",
        secondaryDomainNames=["logic", "agent", "field", "office", "worker"],
        outputFolder=".",
    )
    g.generate()
