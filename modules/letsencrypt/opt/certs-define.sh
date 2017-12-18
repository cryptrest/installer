#!/bin/sh

CRYPTREST_LETSENCRYPT_PRIVATE_KEY_FILE="$CRYPTREST_LETSENCRYPT_ETC_SYS_DIR/$CRYPTREST_DOMAIN/privkey.pem"


# PUBLIC_KEY_PINS
letsencrypt_public_key_pins_define()
{
    local hash=''

    for bit in $CRYPTREST_SSL_BITS; do
        # Let's Encrypt
        for pem in $CRYPTREST_LETSENCRYPT_PEM_FILES; do
            hash="$(curl -s "$CRYPTREST_LETSENCRYPT_URL$pem" | openssl x509 -pubkey | openssl pkey -pubin -outform der | openssl dgst -sha${bit} -binary | base64)"
            CRYPTREST_PUBLIC_KEY_PINS="${CRYPTREST_PUBLIC_KEY_PINS}pin-sha$bit=\"$hash\"; "
        done

        # RSA
        hash="$(openssl rsa -pubout -in "$CRYPTREST_LETSENCRYPT_PRIVATE_KEY_FILE" -outform DER | openssl dgst -sha${bit} -binary | openssl enc -base64)"
        CRYPTREST_PUBLIC_KEY_PINS="${CRYPTREST_PUBLIC_KEY_PINS}pin-sha${bit}=\"${hash}\"; "
    done
}
