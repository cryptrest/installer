#!/bin/sh

CONF_TEMPLATE_FILE_EXT='conf.template'


nginx_links_define()
{
    local conf_file="$1"
    local conf_file_name="$(basename "$conf_file")"

    rm -f "/etc/nginx/sites-available/$conf_file_name" && \
    ln -s "$conf_file" "/etc/nginx/sites-available/$conf_file_name" && \
    rm -f "/etc/nginx/sites-enabled/$conf_file_name" && \
    ln -s "/etc/nginx/sites-available/$conf_file_name" "/etc/nginx/sites-enabled/$conf_file_name" && \
    nginx -t -c "/etc/nginx/sites-enabled/$conf_file_name"
}

nginx_config_define()
{
    local domain="$1"
    local conf_file="$2"
    local template_file="$3"

    cp -f "$template_file" "$conf_file" && \
    chown "$CRYPTREST_USER.$CRYPTREST_USER" "$conf_file" && \
    chmod 400 "$conf_file"

    sed -i "s/\[DOMAIN\]/$domain/g" "$conf_file" && \
    sed -i "s/\[CRYPTREST_DOMAIN\]/$CRYPTREST_DOMAIN/g" "$conf_file" && \
    sed -i "s#\[ROOT_WWW\]#$CRYPTREST_WWW_DIR#g" "$conf_file" && \
    sed -i "s#\[SERVER_CIPHERS\]#$SERVER_CIPHERS#g" "$conf_file" && \
    sed -i "s#\[LETSENCRYPT_DIR\]#$CRYPTREST_LETSENCRYPT_ETC_SYS_DIR#g" "$conf_file" && \
    sed -i "s#\[PUBLIC_KEY_PINS\]#$PUBLIC_KEY_PINS#g" "$conf_file"
}

nginx_configs_define()
{
    local domain_prefix=''
    local template_file=''
    local conf_file=''

    echo ''

    for domain in $CRYPTREST_DOMAINS; do
        domain_prefix="$(echo "$domain" | sed "s/$CRYPTREST_DOMAIN//")"
        template_file="$CRYPTREST_ETC_NGINX_DIR/$domain_prefix$CONF_TEMPLATE_FILE_EXT"
        conf_file="$CRYPTREST_ETC_NGINX_DIR/$domain_prefix$CRYPTREST_DOMAIN.conf"

        if [ -f "$template_file" ]; then
            nginx_config_define "$domain" "$conf_file" "$template_file" && \
            nginx_links_define "$domain" "$conf_file" && \
            echo "NGinx config and links has been defined for '$domain'"
        fi
    done

    echo ''
}
