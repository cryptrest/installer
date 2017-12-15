#!/bin/sh

CURRENT_DIR="$(cd $(dirname $0) && pwd -P)"

CRYPTREST_NGINX_PATH="${HOME}/nginx"


nginx_prepare()
{
    rm -rf "$CRYPTREST_NGINX_PATH"
}

#nginx_download()
#{
#    # Not need
#}

nginx_install()
{
    mkdir -p "$CRYPTREST_NGINX_PATH" && \
    chmod 700 "$CRYPTREST_NGINX_PATH"
}

nginx_define()
{
    cp "$CURRENT_DIR/"*.sh "$CRYPTREST_NGINX_PATH" && \
    cp "$CURRENT_DIR/"*.conf.template "$CRYPTREST_NGINX_PATH" && \
    chmod 400 "$CRYPTREST_NGINX_PATH/"* && \
    rm -f "$CRYPTREST_NGINX_PATH/$(basename $0)"
}


echo ''
echo 'NGinx:'
echo ''

nginx_prepare && \
#nginx_download && \
nginx_install && \
nginx_define
