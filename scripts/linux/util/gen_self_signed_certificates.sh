# general
OUTPUT_FOLDER="pki"

# x509
C="AU" # country name
ST="QLD" # state or province name
O="Synerty" # organziation name

VALID_DAYS=3650 # for all certificates



# END OF CONFIG
# and STOP, unless you know what you are doing.

set -o errexit
set -o nounset

# based on https://blog.devolutions.net/2020/07/tutorial-how-to-generate-secure-self-signed-server-and-client-certificates-with-openssl/
# with x509_config files

CA_CONFIG="
[req]
prompt                 = no
distinguished_name     = dn
[ dn ]
countryName            = ${C}
stateOrProvinceName    = ${ST}
localityName           = N/A
organizationName       = ${O}
commonName             = PEEK SELF-SIGNED CA
[ ext ]
basicConstraints       = CA:TRUE
"

CERT_CONFIG="
[ req ]
prompt                 = no
days                   = 365
distinguished_name     = req_distinguished_name
req_extensions         = v3_req


[ req_distinguished_name ]
countryName            = ${C}
stateOrProvinceName    = ${ST}
localityName           = N/A
organizationName       = ${O}
commonName             = *.peek.local

[ v3_req ]
basicConstraints     = CA:FALSE
subjectKeyIdentifier = hash
keyUsage             = digitalSignature, keyEncipherment
extendedKeyUsage     = serverAuth, clientAuth
subjectAltName       = @sans

[ sans ]
DNS.0 = agent.peek.local
DNS.1 = field.peek.local
DNS.2 = logic.peek.local
DNS.3 = office.peek.local
DNS.4 = worker.peek.local
"

function cleanup() {
  # clean up last run
  #================
  rm -rf $OUTPUT_FOLDER
  mkdir -p $OUTPUT_FOLDER

  #================
}

function genCA() {
  #================
  pushd $OUTPUT_FOLDER

  echo generate CA Private Key
  openssl ecparam -name prime256v1 -genkey -noout -out ca.key

  echo generate CA Certificate
  openssl req -new -x509 -sha256 -nodes -key ca.key -out ca.crt \
   -subj "/C=${C}/ST=${ST}/O=${O}/CN=PEEK SELF SIGNED CA" \
   -config <(echo "$CA_CONFIG") \
   -extensions ext \
   -days $VALID_DAYS
  
  popd
  #================
}


function genLogicAgentFieldOfficeWorker() {
#================
pushd $OUTPUT_FOLDER
name='peek'
# for name in logic agent field office worker;
# do
    echo generate Peek $name Certificate Private Key
    openssl ecparam -name prime256v1 -genkey -noout -out "$name".key

    echo generate Peek $name Certificate Signing Request - CSR
    openssl req -new -sha256 -key "$name".key -out "$name".csr \
    -config <(echo "$CERT_CONFIG")

    echo generate Peek $name Certificate
    openssl x509 -req -in "$name".csr -CA ca.crt -CAkey ca.key \
    -extfile <(echo "$CERT_CONFIG") \
    -extensions v3_req \
    -CAcreateserial -out "$name".crt -days $VALID_DAYS -sha256 \
# done
popd

}


function verify() {
  pushd $OUTPUT_FOLDER
  echo verify signatures
  openssl x509 -in ca.crt -noout -subject -dates
  echo
  openssl x509 -in peek.crt -noout -subject -dates
  echo
  openssl verify -CAfile ca.crt peek.crt
  # openssl verify -CAfile ca.crt {logic,agent,field,office,worker}.crt
  echo
  popd
}


function bundle() {
  pushd $OUTPUT_FOLDER
  echo make pem bundles
  # for name in logic agent field office worker;
  name="peek"
  # do
    cat "$name".key "$name".crt ca.crt > "$name"_bundle.pem
  # done

  echo make Peek trusted peers.pem
  cat peek.crt > peers.pem
  # cat {agent,field,office,worker}.crt > peers.pem
  popd
}

function main() {
  cleanup
  echo

  genCA
  echo

  genLogicAgentFieldOfficeWorker
  echo

  verify
  echo

  bundle

}

main




#function genLogic() {
#  #================
#  echo generate Peek Logic Certificate Private Key
#  openssl ecparam -name prime256v1 -genkey -noout -out logic.key
#
#  echo generate Peek Logic Certificate Signing Request - CSR
#  openssl req -new -sha256 -key logic.key -out logic.csr \
#   -subj "/C=NZ/ST=CAN/O=Synerty/CN=logic.peek.local"
#      #Country Name (2 letter code) [AU]:CA
#      #
#      #State or Province Name (full name) [Some-State]:QC
#      #
#      #Locality Name (eg, city) []:Lavaltrie
#      #
#      #Organization Name (eg, company) [Internet Widgits Pty Ltd]:Devolutions inc.
#      #
#      #Organizational Unit Name (eg, section) []:Security
#      #
#      #Common Name (e.g. server FQDN or YOUR name) []:devolutions.net
#      #
#      #Email Address []:security@devolutions.net
#
#      # set password
#      # ^x^GT+HEy]h9C@8>ZBrb%P>{
#
#  echo generate Peek Logic Certificate
#  openssl x509 -req -in logic.csr -CA ca.crt -CAkey ca.key \
#   -CAcreateserial -out logic.crt -days 1000 -sha256
#  #================
#}