#!/bin/sh

CRYPTREST__COMMON_WWW_DIR="$CRYPTREST_WWW_DIR/_common"
CRYPTREST__COMMON_WWW_HTML_DIR="$CRYPTREST__COMMON_WWW_DIR/html"
CRYPTREST__COMMON_WWW_HTML_ERRORS_DIR="$CRYPTREST__COMMON_WWW_HTML_DIR/errors"
CRYPTREST__COMMON_WWW_ASSETS_DIR="$CRYPTREST__COMMON_WWW_DIR/assets"
CRYPTREST__COMMON_WWW_ASSETS_ICONS_DIR="$CRYPTREST__COMMON_WWW_ASSETS_DIR/icons"
CRYPTREST__COMMON_TITLE='CryptREST Common'


cryptrest_common_prepare()
{
    if [ -d "$CRYPTREST__COMMON_WWW_DIR" ]; then
        chmod 700 "$CRYPTREST__COMMON_WWW_DIR"
    fi
    if [ -d "$CRYPTREST__COMMON_WWW_HTML_DIR" ]; then
        chmod 700 "$CRYPTREST__COMMON_WWW_HTML_DIR"
    fi
    if [ -d "$CRYPTREST__COMMON_WWW_HTML_ERRORS_DIR" ]; then
        chmod 700 "$CRYPTREST__COMMON_WWW_HTML_ERRORS_DIR"
    fi
    if [ -d "$CRYPTREST__COMMON_WWW_ASSETS_DIR" ]; then
        chmod 700 "$CRYPTREST__COMMON_WWW_ASSETS_DIR"
    fi

    rm -rf "$CRYPTREST__COMMON_WWW_DIR"
}

cryptrest_common_install()
{
    mkdir -p "$CRYPTREST__COMMON_WWW_HTML_DIR" && \
    chmod 700 "$CRYPTREST__COMMON_WWW_HTML_DIR"

}

cryptrest_common_define()
{
    cp -r "$CRYPTREST_CURRENT_DIR/_common/www/"* "$CRYPTREST__COMMON_WWW_DIR/" && \
    chmod 400 "$CRYPTREST__COMMON_WWW_DIR/"* && \
    chmod 700 "$CRYPTREST__COMMON_WWW_HTML_DIR" && \
    chmod 444 "$CRYPTREST__COMMON_WWW_HTML_DIR/"*.html && \
    chmod 700 "$CRYPTREST__COMMON_WWW_HTML_ERRORS_DIR" && \
    chmod 444 "$CRYPTREST__COMMON_WWW_HTML_ERRORS_DIR/"*.html && \
    chmod 555 "$CRYPTREST__COMMON_WWW_HTML_ERRORS_DIR" && \
    chmod 555 "$CRYPTREST__COMMON_WWW_HTML_DIR" && \
    chmod 700 "$CRYPTREST__COMMON_WWW_ASSETS_DIR" && \
    chmod 700 "$CRYPTREST__COMMON_WWW_ASSETS_ICONS_DIR" && \
    chmod 444 "$CRYPTREST__COMMON_WWW_ASSETS_ICONS_DIR/"* && \
    chmod 555 "$CRYPTREST__COMMON_WWW_ASSETS_ICONS_DIR" && \
    chmod 555 "$CRYPTREST__COMMON_WWW_ASSETS_DIR" && \
    chmod 555 "$CRYPTREST__COMMON_WWW_DIR" && \

    echo "$CRYPTREST__COMMON_TITLE: init"
    echo ''
}


cryptrest_common_prepare && \
cryptrest_common_install && \
cryptrest_common_define
