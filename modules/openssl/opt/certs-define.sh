#!/bin/sh

CRYPTREST_OPENSSL_SERVER_CIPHERS="$(openssl ciphers)"


CRYPTREST_OPENSSL_DHPARAM_KEY_FILE="$CRYPTREST_SSL_OPENSSL_DOMAIN_DIR/dhparam.pem"
CRYPTREST_OPENSSL_ECDSA_KEY_FILE="$CRYPTREST_SSL_OPENSSL_DOMAIN_DIR/ecdsa.key"
CRYPTREST_OPENSSL_ECDSA_CSR_FILE="$CRYPTREST_SSL_OPENSSL_DOMAIN_DIR/ecdsa.csr"
CRYPTREST_OPENSSL_CSR_CONF_FILE="$CRYPTREST_ETC_OPENSSL_DIR/csr-$CRYPTREST_DOMAIN.conf"


# HD Param
openssl_hd_param_define()
{
    openssl dhparam -out "$CRYPTREST_OPENSSL_DHPARAM_KEY_FILE" "$CRYPTREST_SSL_KEY_SIZE"
}

# ECDSA
openssl_ecdsa_define()
{
    if [ -f "$CRYPTREST_OPENSSL_CSR_CONF_FILE" ]; then
        openssl req -new -sha512 -key "$CRYPTREST_OPENSSL_PRIVATE_KEY_FILE" -out "$CRYPTREST_OPENSSL_ECDSA_CSR_FILE" -subj "/CN=$CRYPTREST_DOMAIN" -config "$CRYPTREST_OPENSSL_CSR_CONF_FILE"
#        openssl ecparam -genkey -name secp384r1 | openssl ec -out "$CRYPTREST_OPENSSL_ECDSA_KEY_FILE" && openssl req -new -sha256 -key "$CRYPTREST_OPENSSL_ECDSA_CSR_FILE" -nodes -out "$CRYPTREST_OPENSSL_ECDSA_CSR_FILE" -outform pem
    fi
}

# PUBLIC_KEY_PINS
openssl_public_key_pins_define()
{
    local hash=''

#    for bit in $CRYPTREST_SSL_BITS; do
#        # ECDSA
#        hash="$(openssl ec -pubout -in "$CRYPTREST_LETSENCRYPT_ECDSA_CSR_FILE" -outform DER | openssl dgst -sha${bit} -binary | openssl enc -base64)"
#        CRYPTREST_PUBLIC_KEY_PINS="${CRYPTREST_PUBLIC_KEY_PINS}pin-sha${bit}=\"${hash}\"; "
#    done
}
