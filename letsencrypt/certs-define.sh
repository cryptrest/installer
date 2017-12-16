#!/bin/sh

PUBLIC_KEY_PINS=''
SERVER_CIPHERS="$(openssl ciphers)"

LETSENCRYPT_URL='https://letsencrypt.org/certs/'
LETSENCRYPT_PEMS='lets-encrypt-x4-cross-signed.pem lets-encrypt-x3-cross-signed.pem isrgrootx1.pem'
LETSENCRYPT_DIR='/etc/letsencrypt/live'
LETSENCRYPT_BITS='256'

CRYPTREST_LETSENCRYPT_DHPARAM_KEY_FILE="${LETSENCRYPT_DIR}/${DOMAIN}/dhparam.pem"
CRYPTREST_LETSENCRYPT_PRIVATE_KEY_FILE="${LETSENCRYPT_DIR}/${DOMAIN}/privkey.pem"
CRYPTREST_LETSENCRYPT_ECDSA_KEY_FILE="${LETSENCRYPT_DIR}/${DOMAIN}/ecdsa.key"
CRYPTREST_LETSENCRYPT_ECDSA_CSR_FILE="${LETSENCRYPT_DIR}/${DOMAIN}/ecdsa.csr"
CRYPTREST_LETSENCRYPT_CSR_CONF_FILE="$CRYPTREST_ETC_LETSENCRYPT_DIR/csr-$CRYPTREST_DOMAIN.conf"

# HD Param
letsencrypt_hd_param_define()
{
    openssl dhparam -out "$CRYPTREST_LETSENCRYPT_DHPARAM_KEY_FILE" 4096
}

# ECDSA
letsencrypt_ecdsa_define()
{
    if [ -f "$CRYPTREST_LETSENCRYPT_CSR_CONF_FILE" ]; then
        openssl req -new -sha512 -key "$CRYPTREST_LETSENCRYPT_PRIVATE_KEY_FILE" -out "$CRYPTREST_LETSENCRYPT_ECDSA_CSR_FILE" -subj "/CN=$CRYPTREST_DOMAIN" -config "$CRYPTREST_LETSENCRYPT_CSR_CONF_FILE"
#        openssl ecparam -genkey -name secp384r1 | openssl ec -out "$CRYPTREST_LETSENCRYPT_ECDSA_KEY_FILE" && openssl req -new -sha256 -key "$CRYPTREST_LETSENCRYPT_ECDSA_CSR_FILE" -nodes -out "$CRYPTREST_LETSENCRYPT_ECDSA_CSR_FILE" -outform pem
    fi
}

# PUBLIC_KEY_PINS
letsencrypt_public_key_pins_define()
{
    local hash=''

    for bit in $LETSENCRYPT_BITS; do
        # Let's Encrypt
        for pem in $LETSENCRYPT_PEMS; do
            hash="$(curl -s "${LETSENCRYPT_URL}${pem}" | openssl x509 -pubkey | openssl pkey -pubin -outform der | openssl dgst -sha${bit} -binary | base64)"
            PUBLIC_KEY_PINS="${PUBLIC_KEY_PINS}pin-sha${bit}=\"${hash}\"; "
        done

        # RSA
        hash="$(openssl rsa -pubout -in "$CRYPTREST_LETSENCRYPT_PRIVATE_KEY_FILE" -outform DER | openssl dgst -sha${bit} -binary | openssl enc -base64)"
        PUBLIC_KEY_PINS="${PUBLIC_KEY_PINS}pin-sha${bit}=\"${hash}\"; "

        # ECDSA
#        hash="$(openssl ec -pubout -in "$CRYPTREST_LETSENCRYPT_ECDSA_CSR_FILE" -outform DER | openssl dgst -sha${bit} -binary | openssl enc -base64)"
#        PUBLIC_KEY_PINS="${PUBLIC_KEY_PINS}pin-sha${bit}=\"${hash}\"; "
    done
}
