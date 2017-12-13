#!/bin/sh

CURRENT_DIR="$(cd $(dirname $0) && pwd -P)"

CERTS_DEFINE_FILE="$CURRENT_DIR/certs-define.sh"
NGINX_DIR="$CURRENT_DIR/../nginx"
NGINX_CONFIG_DEFINE_FILE="$NGINX_DIR/config-define.sh"

DOMAIN='crypt.rest'
UPSTREAM='cryptrest'
ROOT_WWW="/home/$UPSTREAM/www/rest"


. $CERTS_DEFINE_FILE
. $NGINX_CONFIG_DEFINE_FILE


ecdsa_define
public_key_pins_define
hd_param_define

nginx_config_define

#/home/$UPSTREAM/letsencrypt/certbot/certbot-auto certonly --webroot -d $DOMAIN -d www.$DOMAIN --email $DOMAIN@gmail.com --csr $ECDSA_CSR --agree-tos
/home/$UPSTREAM/letsencrypt/certbot/certbot-auto certonly --standalone --email $DOMAIN@gmail.com --renew-by-default --rsa-key-size 4096 -d $DOMAIN -d www.$DOMAIN --pre-hook "service nginx stop" --post-hook "service nginx start"
