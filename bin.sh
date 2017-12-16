#!/bin/sh

CURRENT_DIR="${CURRENT_DIR:=$(cd $(dirname $0) && pwd -P)}"

CRYPTREST_GIT_BRANCH="${CRYPTREST_GIT_BRANCH:=master}"
CRYPTREST_GIT_URL="https://github.com/cryptrest/installer/archive/$CRYPTREST_GIT_BRANCH.tar.gz"

CRYPTREST_TITLE='CryptREST'
CRYPTREST_DIR="$HOME/.cryptrest"
CRYPTREST_ENV_FILE="$CRYPTREST_DIR/.env"
CRYPTREST_ENV_DIR="$CRYPTREST_DIR/env"
CRYPTREST_BIN_DIR="$CRYPTREST_DIR/bin"
CRYPTREST_SRC_DIR="$CRYPTREST_DIR/src"
CRYPTREST_ETC_DIR="$CRYPTREST_DIR/etc"
CRYPTREST_WWW_DIR="$CRYPTREST_DIR/www"
CRYPTREST_TMP_DIR="${TMPDIR:=/tmp}/cryptrest"
CRYPTREST_INSTALLER_DIR="$CRYPTREST_DIR/installer-$CRYPTREST_GIT_BRANCH"
CRYPTREST_WWW_INSTALLER_DIR="$CRYPTREST_WWW_DIR/installer"
CRYPTREST_WWW_INSTALLER_HTML_FILE="$CRYPTREST_WWW_INSTALLER_DIR/index.html"

CRYPTREST_MODULES='go letsencrypt nginx'
CRYPTREST_IS_LOCAL=1


cryptrest_is_local()
{
    for i in $CRYPTREST_MODULES; do
        if [ -d "$CURRENT_DIR/$i" ] && [ -f "$CURRENT_DIR/$i/install.sh" ]; then
            CRYPTREST_IS_LOCAL=0
            break
        fi
    done

    return $CRYPTREST_IS_LOCAL
}


cryptrest_init()
{
    rm -f "$CRYPTREST_ENV_FILE" && \
    rm -rf "$CRYPTREST_WWW_INSTALLER_DIR" && \
    mkdir -p "$CRYPTREST_DIR" && \
    chmod 700 "$CRYPTREST_DIR" && \
    mkdir -p "$CRYPTREST_ENV_DIR" && \
    chmod 700 "$CRYPTREST_ENV_DIR" && \
    mkdir -p "$CRYPTREST_SRC_DIR" && \
    chmod 700 "$CRYPTREST_SRC_DIR" && \
    mkdir -p "$CRYPTREST_BIN_DIR" && \
    chmod 700 "$CRYPTREST_BIN_DIR" && \
    mkdir -p "$CRYPTREST_ETC_DIR" && \
    chmod 700 "$CRYPTREST_ETC_DIR" && \
    mkdir -p "$CRYPTREST_WWW_DIR" && \
    chmod 700 "$CRYPTREST_WWW_DIR" && \
    mkdir -p "$CRYPTREST_WWW_INSTALLER_DIR" && \
    chmod 700 "$CRYPTREST_WWW_INSTALLER_DIR" && \
    mkdir -p "$CRYPTREST_TMP_DIR" && \
    chmod 700 "$CRYPTREST_TMP_DIR" && \
    mkdir -p "$CRYPTREST_INSTALLER_DIR" && \
    chmod 700 "$CRYPTREST_INSTALLER_DIR" && \
    echo '' > "$CRYPTREST_ENV_FILE" && \
    chmod 600 "$CRYPTREST_ENV_FILE" && \
    echo "# $CRYPTREST_TITLE" > "$CRYPTREST_ENV_FILE"
    echo "export CRYPTREST_DIR=\"$HOME/.cryptrest\"" >> "$CRYPTREST_ENV_FILE"
    echo "export PATH=\"\$PATH:\$CRYPTREST_DIR/bin\"" >> "$CRYPTREST_ENV_FILE"
    echo '' >> "$CRYPTREST_ENV_FILE"

    echo ''
    echo "$CRYPTREST_TITLE structure: init"
}

cryptrest_local()
{
    echo "$CRYPTREST_TITLE mode: local"
    echo ''

    for i in $CRYPTREST_MODULES; do
        . "$CURRENT_DIR/$i/install.sh"
    done
}

cryptrest_download()
{
    cd "$CRYPTREST_DIR" && \
    curl -SL "$CRYPTREST_GIT_URL" | tar -xz
    if [ $? -ne 0 ]; then
        echo "$CRYPTREST_TITLE: Some errors with download"
        rm -rf "$CRYPTREST_DIR"

        exit 1
    fi
}

cryptrest_network()
{
    echo "$CRYPTREST_TITLE mode: network"
    echo ''

    cryptrest_download && \
    chmod 700 "$CRYPTREST_DIR" && \
    "$CRYPTREST_INSTALLER_DIR/bin.sh"
}

cryptrest_install()
{
    cryptrest_is_local
    if [ $? -eq 0 ]; then
        cryptrest_local && \
        cp "$CURRENT_DIR/bin.sh" "$CRYPTREST_WWW_INSTALLER_HTML_FILE" && \
        [ "$CURRENT_DIR" != "$CRYPTREST_INSTALLER_DIR" ] && \
        rm -f "$CRYPTREST_INSTALLER_DIR/bin.sh" && \
        cp "$CURRENT_DIR/bin.sh" "$CRYPTREST_INSTALLER_DIR/bin.sh"
    else
        cryptrest_network && \
        cp "$CRYPTREST_INSTALLER_DIR/bin.sh" "$CRYPTREST_WWW_INSTALLER_HTML_FILE"
    fi
}

cryptrest_define()
{
    chmod 444 "$CRYPTREST_WWW_INSTALLER_HTML_FILE" && \
    chmod 400 "$CRYPTREST_ENV_FILE" && \
    chmod 500 "$CRYPTREST_INSTALLER_DIR/bin.sh"
}


cryptrest_init && \
cryptrest_install && \
cryptrest_define
