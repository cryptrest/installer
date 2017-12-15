#!/bin/sh

CRYPTREST_NGINX_DIR="$CRYPTREST_ENV_DIR/nginx"
CRYPTREST_NGINX_PATH="$CRYPTREST_SRC_DIR/nginx"
CRYPTREST_NGINX_ETC_DIR="$CRYPTREST_ETC_DIR/nginx"


nginx_prepare()
{
    rm -rf "$CRYPTREST_NGINX_ETC_DIR" && \
    rm -rf "$CRYPTREST_NGINX_PATH" && \
    rm -rf "$CRYPTREST_NGINX_DIR"
}

nginx_install()
{
    mkdir -p "$CRYPTREST_NGINX_ETC_DIR" && \
    chmod 700 "$CRYPTREST_NGINX_ETC_DIR" && \
    mkdir -p "$CRYPTREST_NGINX_PATH" && \
    chmod 700 "$CRYPTREST_NGINX_PATH" && \
    mkdir -p "$CRYPTREST_NGINX_DIR" && \
    chmod 700 "$CRYPTREST_NGINX_DIR"
}

nginx_define()
{
    cp "$CURRENT_DIR/nginx/"*.template "$CRYPTREST_NGINX_ETC_DIR/" && \
    chmod 400 "$CRYPTREST_NGINX_ETC_DIR/"* && \
    cp "$CURRENT_DIR/nginx/"*.sh "$CRYPTREST_NGINX_DIR/" && \
    chmod 400 "$CRYPTREST_NGINX_DIR/"*.sh && \
    rm -f "$CRYPTREST_NGINX_DIR/install"*
}


echo ''
echo 'NGinx: init'
echo ''

nginx_prepare && \
nginx_install && \
nginx_define
