#!/bin/sh

CRYPTREST__COMMON_OPT_DIR="$CRYPTREST_OPT_DIR/.common"
CRYPTREST__COMMON_ETC_DIR="$CRYPTREST_ETC_DIR/.common"
CRYPTREST__COMMON_ETC_ASSETS_DIR="$CRYPTREST__COMMON_ETC_DIR/assets"
CRYPTREST_BIN_INIT_FILE="$CRYPTREST_BIN_DIR/cryptrest-init"
CRYPTREST__COMMON_TITLE='CryptREST Common'



nginx_prepare()
{
    if [ -d "$CRYPTREST__COMMON_ETC_ASSETS_DIR" ]; then
        chmod 700 "$CRYPTREST__COMMON_ETC_ASSETS_DIR" && \
        rm -rf "$CRYPTREST__COMMON_ETC_ASSETS_DIR"
    fi

    rm -rf "$CRYPTREST__COMMON_ETC_DIR" && \
    rm -rf "$CRYPTREST__COMMON_OPT_DIR"
}

nginx_install()
{
    mkdir -p "$CRYPTREST__COMMON_ETC_DIR" && \
    chmod 700 "$CRYPTREST__COMMON_ETC_DIR" && \
    mkdir -p "$CRYPTREST__COMMON_OPT_DIR" && \
    chmod 700 "$CRYPTREST__COMMON_OPT_DIR"
}

nginx_define()
{
    cp -r "$CURRENT_DIR/.common/etc/"* "$CRYPTREST__COMMON_ETC_DIR/" && \
    chmod 400 "$CRYPTREST__COMMON_ETC_DIR/"* && \
    chmod 700 "$CRYPTREST__COMMON_ETC_ASSETS_DIR" && \
    chmod 444 "$CRYPTREST__COMMON_ETC_ASSETS_DIR/"*.html && \
    chmod 555 "$CRYPTREST__COMMON_ETC_ASSETS_DIR" && \
    cp "$CURRENT_DIR/.common/opt/"*.sh "$CRYPTREST__COMMON_OPT_DIR/" && \
    chmod 400 "$CRYPTREST__COMMON_OPT_DIR/"*.sh && \
    rm -f "$CRYPTREST__COMMON_OPT_DIR/install"* && \
    ln -s "$CRYPTREST__COMMON_OPT_DIR/init.sh" "$CRYPTREST_BIN_INIT_FILE" && \
    chmod 500 "$CRYPTREST_BIN_INIT_FILE" && \

    echo "$CRYPTREST__COMMON_TITLE: init"
    echo ''
}


nginx_prepare && \
nginx_install && \
nginx_define
