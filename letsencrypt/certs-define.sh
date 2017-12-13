#!/bin/sh

LETSENCRYPT_URL='https://letsencrypt.org/certs/'
LETSENCRYPT_PEMS='lets-encrypt-x4-cross-signed.pem lets-encrypt-x3-cross-signed.pem isrgrootx1.pem'
LETSENCRYPT_DIR='/etc/letsencrypt/live'
LETSENCRYPT_BITS='256'

PUBLIC_KEY_PINS=''
SERVER_CIPHERS="$(openssl ciphers)"

ECDSA_KEY="${LETSENCRYPT_DIR}/${DOMAIN}/ecdsa.key"
ECDSA_CSR="${LETSENCRYPT_DIR}/${DOMAIN}/ecdsa.csr"

# HD Param
hd_param_define()
{
    openssl dhparam -out ${LETSENCRYPT_DIR}/${DOMAIN}/dhparam.pem 4096
}

# ECDSA
ecdsa_define()
{
    openssl req -new -sha512 -key ${LETSENCRYPT_DIR}/${DOMAIN}/privkey.pem -out $ECDSA_CSR -subj "/CN=$DOMAIN" -config $CURRENT_DIR/csr-$DOMAIN.conf
#    openssl ecparam -genkey -name secp384r1 | openssl ec -out $ECDSA_KEY && openssl req -new -sha256 -key $ECDSA_KEY -nodes -out $ECDSA_CSR -outform pem
}

# PUBLIC_KEY_PINS
public_key_pins_define()
{
    local hash=''

    for bit in $LETSENCRYPT_BITS; do
        # Let's Encrypt
        for pem in $LETSENCRYPT_PEMS; do
            hash="$(curl -s "${LETSENCRYPT_URL}${pem}" | openssl x509 -pubkey | openssl pkey -pubin -outform der | openssl dgst -sha${bit} -binary | base64)"
            PUBLIC_KEY_PINS="${PUBLIC_KEY_PINS}pin-sha${bit}=\"${hash}\"; "
        done

        # RSA
        hash="$(openssl rsa -pubout -in ${LETSENCRYPT_DIR}/${DOMAIN}/privkey.pem -outform DER | openssl dgst -sha${bit} -binary | openssl enc -base64)"
        PUBLIC_KEY_PINS="${PUBLIC_KEY_PINS}pin-sha${bit}=\"${hash}\"; "

        # ECDSA
#        hash="$(openssl ec -pubout -in $ECDSA_CSR -outform DER | openssl dgst -sha${bit} -binary | openssl enc -base64)"
#        PUBLIC_KEY_PINS="${PUBLIC_KEY_PINS}pin-sha${bit}=\"${hash}\"; "
    done
}
