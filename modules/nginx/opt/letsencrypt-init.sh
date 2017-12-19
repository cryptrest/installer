#!/bin/sh

CURRENT_DIR="${CURRENT_DIR:=$(cd $(dirname $0) && pwd -P)}"

. "$CURRENT_DIR/../.env"

CRYPTREST_DIR="${CRYPTREST_DIR:=$(cd $(dirname $0)/../ && pwd -P)}"
CRYPTREST_PUBLIC_KEY_PINS=''

CRYPTREST_WWW_DIR="$CRYPTREST_DIR/www"
CRYPTREST_ETC_DIR="$CRYPTREST_DIR/etc"
CRYPTREST_SSL_DIR="$CRYPTREST_DIR/ssl"
CRYPTREST_OPT_DIR="$CRYPTREST_DIR/opt"

CRYPTREST_OPENSSL_OPT_DIR="$CRYPTREST_OPT_DIR/openssl"
CRYPTREST_OPENSSL_ETC_DIR="$CRYPTREST_ETC_DIR/openssl"
CRYPTREST_OPENSSL_SSL_DIR="$CRYPTREST_SSL_DIR/openssl"
CRYPTREST_OPENSSL_SSL_DOMAIN_DIR="$CRYPTREST_OPENSSL_SSL_DIR/$CRYPTREST_DOMAIN"

CRYPTREST_NGINX_LOG_DIR="$CRYPTREST_DIR/log/nginx"
CRYPTREST_NGINX_ETC_DIR="$CRYPTREST_ETC_DIR/nginx"
CRYPTREST_NGINX_OPT_DIR="$CRYPTREST_OPT_DIR/nginx"

CRYPTREST_LETSENCRYPT_OPT_DIR="$CRYPTREST_OPT_DIR/letsencrypt"

CRYPTREST_SSL_DOMAIN_DIR="$CRYPTREST_LETSENCRYPT_ETC_SYS_DIR"


. "$CRYPTREST_LETSENCRYPT_OPT_DIR/certs-define.sh"
. "$CRYPTREST_OPENSSL_OPT_DIR/certs-define.sh"
. "$CRYPTREST_NGINX_OPT_DIR/config-define.sh"


letsencrypt_init_prepare()
{
    openssl_domain_dir_define && \
    #openssl_ecdsa_define && \
    openssl_hd_param_define && \
    openssl_ciphers_define && \
    openssl_public_key_pins_define && \
    letsencrypt_public_key_pins_define && \
    nginx -v && \
    nginx_configs_define
}

letsencrypt_init_run()
{
    local domains=''

    for domain in $CRYPTREST_SSL_DOMAINS; do
        domains="$domains -d $domain"
    done

    "$CRYPTREST_DIR/bin/cryptrest-letsencrypt" certonly --standalone --email "$CRYPTREST_EMAIL" --renew-by-default --rsa-key-size "$CRYPTREST_SSL_KEY_SIZE"$domains --pre-hook "$CRYPTREST_NGINX_CMD_STOP" --post-hook "$CRYPTREST_NGINX_CMD_START"
    #"$CRYPTREST_DIR/bin/cryptrest-letsencrypt" certonly --webroot $domains --email "$CRYPTREST_EMAIL" --csr $ECDSA_CSR --agree-tos
}


letsencrypt_init_prepare && \
letsencrypt_init_run
