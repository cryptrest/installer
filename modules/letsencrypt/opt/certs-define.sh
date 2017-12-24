#!/bin/sh

CRYPTREST_LETSENCRYPT_KEYS='cert chain fullchain privkey'
CRYPTREST_LETSENCRYPT_PRIVATE_KEY_FILE="$CRYPTREST_SSL_DOMAIN_DIR/privkey.pem"


letsencrypt_key_links()
{
    local current_dir="$(pwd -P)"

    cd "$CRYPTREST_SSL_DOMAIN_DIR" && \
    for k in $CRYPTREST_LETSENCRYPT_KEYS; do
        rm -f "$k.pem" && \
        ln -s "live/$CRYPTREST_LIB_DOMAIN/$k.pem" "$k.pem"
    done
    cd "$current_dir"
}

# PUBLIC_KEY_PINS
letsencrypt_public_key_pins_define()
{
    local hash=''
    local ssl_bit_size=256  # CRYPTREST_SSL_BIT_SIZE

    # Let's Encrypt
    for pem in $CRYPTREST_LETSENCRYPT_PEM_FILES; do
        hash="$(curl -s "$CRYPTREST_LETSENCRYPT_URL$pem" | openssl x509 -pubkey | openssl pkey -pubin -outform der | openssl dgst -sha$ssl_bit_size -binary | base64)"
        CRYPTREST_PUBLIC_KEY_PINS="${CRYPTREST_PUBLIC_KEY_PINS}pin-sha$ssl_bit_size=\"$hash\"; "
    done

    # RSA
    if [ -f "$CRYPTREST_LETSENCRYPT_PRIVATE_KEY_FILE" ]; then
        hash="$(openssl rsa -pubout -in "$CRYPTREST_LETSENCRYPT_PRIVATE_KEY_FILE" -outform DER | openssl dgst -sha$ssl_bit_size -binary | openssl enc -base64)"
        CRYPTREST_PUBLIC_KEY_PINS="${CRYPTREST_PUBLIC_KEY_PINS}pin-sha$ssl_bit_size=\"$hash\"; "
    fi
}
