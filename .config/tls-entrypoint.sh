#!/bin/bash
. /project/.config/config-wrapper.sh

# Specify where we will install the certificate
CERT_DIR="/home/jcore/ca"
SSL_DIR="/home/jcore/ssl"

# This should be blank to allow webserver to start
PASSPHRASE=""

# Create CA key and Cert if it doesn't exist
if [ ! -f "$CERT_DIR/jcoCA.key" ]; then
  # Create password file if it doesn't exist
  if [ ! -f "$CERT_DIR/password.txt" ]; then
    cat /dev/urandom | tr -dc 'a-zA-Z0-9!@#$%^&*' | fold -w 32 | head -n 1 >"$CERT_DIR/password.txt"
    echo "\n" >>"$CERT_DIR/password.txt"
  fi

  echo "[req]
    default_bits = 2048
    prompt = no
    default_md = sha256
    distinguished_name = dn

    [dn]
    C = FI
    ST = Uusimaa
    L = Raseborg
    O = JCO Digital
    OU = Hosting
    emailAddress = developer@jco.fi
    CN = JCO
    " >"$CERT_DIR/jcoCA.conf"

  # Generate Key
  openssl genpkey -algorithm rsa -des3 -pkeyopt rsa_keygen_bits:2048 -pass "file:$CERT_DIR/password.txt" -out "$CERT_DIR/jcoCA.key"

  #Generate Cert
  openssl req -new -config "$CERT_DIR/jcoCA.conf" -x509 -sha256 -nodes -days 1095 -key "$CERT_DIR/jcoCA.key" -out "$CERT_DIR/jcoCA.pem" -passin "file:$CERT_DIR/password.txt"
fi

# Create host key and cert if they don't exist
if [ ! -f "$SSL_DIR/host.key" ]; then

  DNS=1
  ALTNAME="DNS.${DNS} = localhost"
  for domainRecord in ${DOMAINS[@]}; do
    domain=(${domainRecord//;/ })
    hostName=${domain[1]}
    if [ ${#hostName} -eq 0 ]; then
      hostName=${domain[0]}
    fi
    DNS=$((DNS + 1))
    ALTNAME="$ALTNAME
  DNS.${DNS} = ${hostName}.localhost"
    DNS=$((DNS + 1))
    ALTNAME="$ALTNAME
  DNS.${DNS} = *.${hostName}.localhost"
  done

  echo "[req]
  default_bits = 2048
  prompt = no
  default_md = sha256
  x509_extensions = v3_req
  distinguished_name = dn

  [dn]
  C = FI
  ST = Uusimaa
  L = Raseborg
  O = JCO Digital
  OU = Hosting
  emailAddress = developer@jco.fi
  CN = $DOMAINNAME

  [v3_req]
  subjectAltName = @alt_names

  [alt_names]
  $ALTNAME
  " >"$SSL_DIR/host.conf"

  echo "authorityKeyIdentifier=keyid,issuer
  basicConstraints=CA:FALSE
  keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
  subjectAltName = @alt_names

  [alt_names]
  $ALTNAME
  " >"$SSL_DIR/v3.ext"

  # Generate the Private Key
  openssl genpkey -algorithm rsa -pkeyopt rsa_keygen_bits:2048 -out "$SSL_DIR/host.key"

  # Generate the CSR
  openssl req -new -config "$SSL_DIR/host.conf" -key "$SSL_DIR/host.key" -out "$SSL_DIR/host.csr" -passin pass:$PASSPHRASE

  # Generate the Certificate
  openssl x509 -req -extfile "$SSL_DIR/v3.ext" -days 365 -in "$SSL_DIR/host.csr" -CA "$CERT_DIR/jcoCA.pem" -CAkey "$CERT_DIR/jcoCA.key" -CAcreateserial -out "$SSL_DIR/host.crt" -sha256 -passin "file:$CERT_DIR/password.txt"
fi

chown -R jcore:jcore $CERT_DIR $SSL_DIR
