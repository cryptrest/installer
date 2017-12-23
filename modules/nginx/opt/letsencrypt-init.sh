#!/bin/sh

CURRENT_DIR="${CURRENT_DIR:=$(cd $(dirname $0) && pwd -P)}"

CRYPTREST_ENV_FILE="$CURRENT_DIR/../.env"
CRYPTREST_NGINX_ETC_ENV_FILE="$CURRENT_DIR/../etc/nginx/.env"

if [ ! -f "$CRYPTREST_ENV_FILE" ]; then
    CRYPTREST_ENV_FILE="$CURRENT_DIR/../../.env"
    if [ ! -f "$CRYPTREST_NGINX_ETC_ENV_FILE" ]; then
        CRYPTREST_NGINX_ETC_ENV_FILE="$CURRENT_DIR/../../etc/nginx/.env"
    fi
fi

. "$CRYPTREST_ENV_FILE"
. "$CRYPTREST_NGINX_ETC_ENV_FILE"

CRYPTREST_ENV_FILE="$CURRENT_DIR/../.env"
CRYPTREST_LETSENCRYPT_ETC_ENV_FILE="$CURRENT_DIR/../etc/letsencrypt/.env"

if [ ! -f "$CRYPTREST_ENV_FILE" ]; then
    CRYPTREST_ENV_FILE="$CURRENT_DIR/../../.env"
    if [ ! -f "$CRYPTREST_LETSENCRYPT_ETC_ENV_FILE" ]; then
        CRYPTREST_LETSENCRYPT_ETC_ENV_FILE="$CURRENT_DIR/../../etc/letsencrypt/.env"
    fi
fi

. "$CRYPTREST_LETSENCRYPT_ETC_ENV_FILE"


CRYPTREST_DIR="${CRYPTREST_DIR:=$(cd $(dirname $0)/../ && pwd -P)}"
CRYPTREST_PUBLIC_KEY_PINS=''

CRYPTREST_WWW_DIR="$CRYPTREST_DIR/www"
CRYPTREST_ETC_DIR="$CRYPTREST_DIR/etc"
CRYPTREST_ETC_SSL_DIR="$CRYPTREST_ETC_DIR/ssl"
CRYPTREST_OPT_DIR="$CRYPTREST_DIR/opt"

CRYPTREST_OPENSSL_OPT_DIR="$CRYPTREST_OPT_DIR/openssl"
CRYPTREST_OPENSSL_ETC_DIR="$CRYPTREST_ETC_DIR/openssl"

CRYPTREST_NGINX_VAR_LOG_DIR="$CRYPTREST_DIR/var/log/nginx"
CRYPTREST_NGINX_ETC_DIR="$CRYPTREST_ETC_DIR/nginx"
CRYPTREST_NGINX_OPT_DIR="$CRYPTREST_OPT_DIR/nginx"

CRYPTREST_LETSENCRYPT_OPT_DIR="$CRYPTREST_OPT_DIR/letsencrypt"


letsencrypt_init_prepare()
{
    mkdir -p "$CRYPTREST_WWW_DOMAIN_DIR" && \
    chmod 700 "$CRYPTREST_WWW_DOMAIN_DIR" && \
    mkdir -p "$CRYPTREST_NGINX_LOG_DOMAIN_DIR" && \
    chmod 700 "$CRYPTREST_NGINX_LOG_DOMAIN_DIR" && \
    mkdir -p "$CRYPTREST_OPENSSL_SSL_DOMAIN_DIR" && \
    chmod 700 "$CRYPTREST_OPENSSL_SSL_DOMAIN_DIR" && \
    openssl_domain_dir_define && \
    openssl_session_ticket_key_define && \
    #openssl_ecdsa_define && \
    openssl_hd_param_define && \
    openssl_ciphers_define && \
    #openssl_public_key_pins_define && \
    letsencrypt_public_key_pins_define && \
    nginx -v && \
    nginx_configs_define && \
    chmod 555 "$CRYPTREST_WWW_DOMAIN_DIR"
}

letsencrypt_init_define()
{
    local domains=''

    for domain in $CRYPTREST_DOMAINS; do
        domains="$domains -d $domain"
    done

    "$CRYPTREST_DIR/bin/cryptrest-letsencrypt" certonly --standalone --email "$CRYPTREST_EMAIL" --renew-by-default --rsa-key-size "$CRYPTREST_SSL_BIT_KEY_SIZE"$domains --pre-hook "$CRYPTREST_NGINX_CMD_STOP" --post-hook "$CRYPTREST_NGINX_CMD_START"
    #"$CRYPTREST_DIR/bin/cryptrest-letsencrypt" certonly --webroot $domains --email "$CRYPTREST_EMAIL" --csr $ECDSA_CSR --agree-tos
}

letsencrypt_init_run()
{
    local domains_dir="$CRYPTREST_ETC_DIR/.domains"

    . "$CRYPTREST_NGINX_OPT_DIR/config-define.sh"

    for d in $(ls "$domains_dir"); do
        . "$domains_dir/$d"

        CRYPTREST_OPENSSL_SSL_DOMAIN_DIR="$CRYPTREST_ETC_SSL_DIR/$CRYPTREST_LIB_DOMAIN"
        CRYPTREST_SSL_DOMAIN_DIR="$CRYPTREST_LETSENCRYPT_ETC_SYS_DIR/$CRYPTREST_LIB_DOMAIN"
        CRYPTREST_NGINX_LOG_DOMAIN_DIR="$CRYPTREST_NGINX_VAR_LOG_DIR/$CRYPTREST_LIB_DOMAIN"
        CRYPTREST_WWW_DOMAIN_DIR="$CRYPTREST_WWW_DIR/$d"

        . "$CRYPTREST_LETSENCRYPT_OPT_DIR/certs-define.sh"
        . "$CRYPTREST_OPENSSL_OPT_DIR/certs-define.sh"

        letsencrypt_init_prepare && \
        letsencrypt_init_define
    done
}


letsencrypt_init_run
