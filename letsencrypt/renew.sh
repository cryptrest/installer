#!/bin/sh

CRYPTREST_DIR="${CRYPTREST_DIR:=$(cd $(dirname $0)/../../ && pwd -P)}"
CRYPTREST_WWW_DIR="$CRYPTREST_DIR/www"
CRYPTREST_ETC_DIR="$CRYPTREST_DIR/etc"
CRYPTREST_ETC_NGINX_DIR="$CRYPTREST_ETC_DIR/nginx"
CRYPTREST_ETC_LETSENCRYPT_DIR="$CRYPTREST_ETC_DIR/letsencrypt"
CRYPTREST_OPT_DIR="$CRYPTREST_DIR/opt"
CRYPTREST_OPT_NGINX_DIR="$CRYPTREST_OPT_DIR/nginx"
CRYPTREST_OPT_LETSENCRYPT_DIR="$CRYPTREST_OPT_DIR/letsencrypt"

CRYPTREST_DOMAIN="${CRYPTREST_DOMAIN:=crypt.rest}"
CRYPTREST_DOMAINS="$CRYPTREST_DOMAIN api.$CRYPTREST_DOMAIN installer.$CRYPTREST_DOMAIN"


. "$CRYPTREST_OPT_LETSENCRYPT_DIR/certs-define.sh"
. "$CRYPTREST_OPT_NGINX_DIR/config-define.sh"


#letsencrypt_hd_param_define && \
#letsencrypt_ecdsa_define && \
#letsencrypt_public_key_pins_define && \
#nginx -v && \
nginx_configs_define && \
echo "letsencrypt certonly --standalone --email $DOMAIN@gmail.com --renew-by-default --rsa-key-size 4096 -d $DOMAIN -d www.$DOMAIN -d api.$DOMAIN -d installer.$DOMAIN --pre-hook \"$CRYPTREST_NGINX_CMD_STOP\" --post-hook \"$CRYPTREST_NGINX_CMD_START\""
#letsencrypt certonly --webroot -d $DOMAIN -d www.$DOMAIN -d i.$DOMAIN -d installer.$DOMAIN --email $DOMAIN@gmail.com --csr $ECDSA_CSR --agree-tos
