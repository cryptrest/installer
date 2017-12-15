#!/bin/sh

CURRENT_DIR="$(cd $(dirname $0) && pwd -P)"

CERTS_DEFINE_FILE="$CURRENT_DIR/certs-define.sh"
NGINX_DIR="$CURRENT_DIR/../nginx"
NGINX_CONFIG_DEFINE_FILE="$NGINX_DIR/config-define.sh"

DOMAIN='crypt.rest'
UPSTREAM='cryptrest'
ROOT_WWW="/home/$UPSTREAM/www/rest"
ROOT_WWW_INSTALLER="/home/$UPSTREAM/installer"
CERTBOT_BIN_FILE="/home/$UPSTREAM/.letsencrypt/certbot/certbot-auto"


. $CERTS_DEFINE_FILE
. $NGINX_CONFIG_DEFINE_FILE


letsencrypt_ecdsa_define
letsencrypt_public_key_pins_define
letsencrypt_hd_param_define

nginx_configs_define

#$CERTBOT_BIN_FILE certonly --webroot -d $DOMAIN -d www.$DOMAIN -d i.$DOMAIN -d installer.$DOMAIN --email $DOMAIN@gmail.com --csr $ECDSA_CSR --agree-tos
$CERTBOT_BIN_FILE certonly --standalone --email $DOMAIN@gmail.com --renew-by-default --rsa-key-size 4096 -d $DOMAIN -d www.$DOMAIN -d i.$DOMAIN -d installer.$DOMAIN --pre-hook "service nginx stop" --post-hook "service nginx start"
