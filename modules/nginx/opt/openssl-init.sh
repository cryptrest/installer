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


CRYPTREST_DIR="${CRYPTREST_DIR:=$(cd $(dirname $0)/../ && pwd -P)}"
CRYPTREST_PUBLIC_KEY_PINS=''

CRYPTREST_WWW_DIR="$CRYPTREST_DIR/www"
CRYPTREST_ETC_DIR="$CRYPTREST_DIR/etc"
CRYPTREST_ETC_SSL_DIR="$CRYPTREST_ETC_DIR/ssl"
CRYPTREST_OPT_DIR="$CRYPTREST_DIR/opt"

CRYPTREST_OPENSSL_ETC_DIR="$CRYPTREST_ETC_DIR/openssl"
CRYPTREST_OPENSSL_OPT_DIR="$CRYPTREST_OPT_DIR/openssl"

CRYPTREST_NGINX_VAR_LOG_DIR="$CRYPTREST_DIR/var/log/nginx"
CRYPTREST_NGINX_ETC_DIR="$CRYPTREST_ETC_DIR/nginx"
CRYPTREST_NGINX_OPT_DIR="$CRYPTREST_OPT_DIR/nginx"


openssl_init_prepare()
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
    nginx -v && \
    nginx_configs_define
}


openssl_init_run()
{
    local domains_dir="$CRYPTREST_ETC_DIR/.domains"

    . "$CRYPTREST_NGINX_OPT_DIR/config-define.sh"

    for d in $(ls "$domains_dir"); do
        if [ -f "$domains_dir/$d" ]; then
            . "$domains_dir/$d"

            CRYPTREST_SSL_DOMAIN_DIR="$CRYPTREST_ETC_SSL_DIR/$CRYPTREST_LIB_DOMAIN"
            CRYPTREST_NGINX_LOG_DOMAIN_DIR="$CRYPTREST_NGINX_VAR_LOG_DIR/$CRYPTREST_LIB_DOMAIN"
            CRYPTREST_WWW_DOMAIN_DIR="$CRYPTREST_WWW_DIR/$d"

            . "$CRYPTREST_OPENSSL_OPT_DIR/certs-define.sh"

            openssl_init_prepare
        fi
    done
}


openssl_init_run
