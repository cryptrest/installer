#!/bin/sh

CRYPTREST_LETSENCRYPT_PRIVATE_KEY_FILE="$CRYPTREST_LETSENCRYPT_ETC_SYS_DIR/$CRYPTREST_DOMAIN/privkey.pem"


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
    hash="$(openssl rsa -pubout -in "$CRYPTREST_LETSENCRYPT_PRIVATE_KEY_FILE" -outform DER | openssl dgst -sha$ssl_bit_size -binary | openssl enc -base64)"
    CRYPTREST_PUBLIC_KEY_PINS="${CRYPTREST_PUBLIC_KEY_PINS}pin-sha$ssl_bit_size=\"$hash\"; "
}
