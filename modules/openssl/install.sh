#!/bin/sh

CRYPTREST_OPENSSL_OPT_DIR="$CRYPTREST_OPT_DIR/openssl"
CRYPTREST_OPENSSL_ETC_DIR="$CRYPTREST_ETC_DIR/openssl"
CRYPTREST_OPENSSL_SSL_DIR="$CRYPTREST_SSL_DIR/openssl"
CRYPTREST_OPENSSL_TITLE='OpenSSL'


letsencrypt_prepare()
{
    rm -rf "$CRYPTREST_OPENSSL_OPT_DIR" && \
    rm -rf "$CRYPTREST_OPENSSL_ETC_DIR/" && \
    rm -rf "$CRYPTREST_OPENSSL_SSL_DIR/"
}

letsencrypt_install()
{
    mkdir -p "$CRYPTREST_OPENSSL_OPT_DIR" && \
    chmod 700 "$CRYPTREST_OPENSSL_OPT_DIR" && \
    mkdir -p "$CRYPTREST_OPENSSL_ETC_DIR" && \
    chmod 700 "$CRYPTREST_OPENSSL_ETC_DIR" && \
    mkdir -p "$CRYPTREST_OPENSSL_SSL_DIR" && \
    chmod 700 "$CRYPTREST_OPENSSL_SSL_DIR"
}

letsencrypt_define()
{
    cp "$CRYPTREST_MODULES_DIR/openssl/etc/"*.conf "$CRYPTREST_OPENSSL_ETC_DIR/" && \
    chmod 400 "$CRYPTREST_OPENSSL_ETC_DIR/"* && \
    cp "$CRYPTREST_MODULES_DIR/openssl/opt/"*.sh "$CRYPTREST_OPENSSL_OPT_DIR/" && \
    chmod 400 "$CRYPTREST_OPENSSL_OPT_DIR/"*.sh
}


echo ''
echo "$CRYPTREST_OPENSSL_TITLE: init"
echo ''

letsencrypt_prepare && \
letsencrypt_install && \
letsencrypt_define
