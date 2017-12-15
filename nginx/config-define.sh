#!/bin/sh

NGINX_CONFIG_FILE="$NGINX_DIR/$DOMAIN.conf"
NGINX_CONFIG_TEMPLATE_FILE="$NGINX_CONFIG_FILE.template"
NGINX_CONFIG_INSTALLER_FILE="$NGINX_DIR/installer.$DOMAIN.conf"
NGINX_CONFIG_INSTALLER_TEMPLATE_FILE="$NGINX_CONFIG_INSTALLER_FILE.template"


nginx_config_define()
{
    cp -f "$NGINX_CONFIG_TEMPLATE_FILE" "$NGINX_CONFIG_FILE" && \
    chown "$UPSTREAM.$UPSTREAM" "$NGINX_CONFIG_FILE" && \
    chmod 400 "$NGINX_CONFIG_FILE"

    sed -i "s/\[DOMAIN\]/$DOMAIN/g" "$NGINX_CONFIG_FILE" && \
    sed -i "s/\[UPSTREAM\]/$UPSTREAM/g" "$NGINX_CONFIG_FILE" && \
    sed -i "s#\[ROOT_WWW\]#$ROOT_WWW#g" "$NGINX_CONFIG_FILE" && \
    sed -i "s#\[SERVER_CIPHERS\]#$SERVER_CIPHERS#g" "$NGINX_CONFIG_FILE" && \
    sed -i "s#\[LETSENCRYPT_DIR\]#$LETSENCRYPT_DIR#g" "$NGINX_CONFIG_FILE" && \
    sed -i "s#\[PUBLIC_KEY_PINS\]#$PUBLIC_KEY_PINS#g" "$NGINX_CONFIG_FILE"

    nginx -t 2> /dev/null
}

nginx_installer_config_define()
{
    cp -f "$NGINX_CONFIG_TEMPLATE_FILE" "$NGINX_CONFIG_FILE" && \
    chown "$UPSTREAM.$UPSTREAM" "$NGINX_CONFIG_FILE" && \
    chmod 400 "$NGINX_CONFIG_FILE"

    sed -i "s/\[DOMAIN\]/$DOMAIN/g" "$NGINX_CONFIG_INSTALLER_FILE" && \
    sed -i "s/\[UPSTREAM\]/$UPSTREAM/g" "$NGINX_CONFIG_INSTALLER_FILE" && \
    sed -i "s#\[ROOT_WWW_INSTALLER\]#$ROOT_WWW_INSTALLER#g" "$NGINX_CONFIG_INSTALLER_FILE" && \
    sed -i "s#\[SERVER_CIPHERS\]#$SERVER_CIPHERS#g" "$NGINX_CONFIG_INSTALLER_FILE" && \
    sed -i "s#\[LETSENCRYPT_DIR\]#$LETSENCRYPT_DIR#g" "$NGINX_CONFIG_INSTALLER_FILE" && \
    sed -i "s#\[PUBLIC_KEY_PINS\]#$PUBLIC_KEY_PINS#g" "$NGINX_CONFIG_INSTALLER_FILE"

    nginx -t 2> /dev/null
}

nginx_configs_define()
{
    nginx_config_define
    nginx_installer_config_define
}
