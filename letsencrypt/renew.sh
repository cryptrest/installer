#!/bin/sh

CURRENT_DIR="$(cd $(dirname $0) && pwd -P)"

CERTS_DEFINE_FILE="$CURRENT_DIR/certs-define.sh"
NGINX_DIR="$CURRENT_DIR/../nginx"
NGINX_CONFIG_DEFINE_FILE="$NGINX_DIR/config-define.sh"

DOMAIN='crypt.rest'
UPSTREAM='cryptrest'
ROOT_WWW="$CRYPTREST_DIR/www/rest"
ROOT_WWW_INSTALLER="$CRYPTREST_DIR/www/installer/index.html"


. $CERTS_DEFINE_FILE
. $NGINX_CONFIG_DEFINE_FILE


letsencrypt_ecdsa_define
letsencrypt_public_key_pins_define
letsencrypt_hd_param_define

nginx_configs_define


letsencrypt certonly --webroot -d $DOMAIN -d www.$DOMAIN -d i.$DOMAIN -d installer.$DOMAIN --email $DOMAIN@gmail.com --csr $ECDSA_CSR --agree-tos
letsencrypt certonly --standalone --email $DOMAIN@gmail.com --renew-by-default --rsa-key-size 4096 -d $DOMAIN -d www.$DOMAIN -d i.$DOMAIN -d installer.$DOMAIN --pre-hook "service nginx stop" --post-hook "service nginx start"
