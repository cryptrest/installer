#!/bin/sh

CURRENT_DIR="$(cd $(dirname $0) && pwd -P)"

CRYPTREST_ENV_FILE="$CURRENT_DIR/.env"
CRYPTREST_MODULES_DIR="$CURRENT_DIR/modules"
if [ ! -f "$CRYPTREST_ENV_FILE" ]; then
    CRYPTREST_ENV_FILE="$CURRENT_DIR/../.env"
    CRYPTREST_MODULES_DIR="$CURRENT_DIR/../modules"

    if [ ! -d "$CRYPTREST_MODULES_DIR" ]; then
        CRYPTREST_MODULES_DIR="$(dirname $(readlink "$0"))/../modules"
    fi
fi

echo ''
printf 'CryptREST config file: '
if [ -f "$CRYPTREST_ENV_FILE" ]; then
    . "$CRYPTREST_ENV_FILE"

    echo 'loaded'
else
    echo 'not loaded'
fi

CURRENT_DIR="$(cd $(dirname $0) && pwd -P)"


# CRYPTREST_MODULES='nginx openssl letsencrypt'
CRYPTREST_MODULES="${CRYPTREST_MODULES:=}"
CRYPTREST_INSTALLER_GIT_BRANCH="${CRYPTREST_INSTALLER_GIT_BRANCH:=master}"

CRYPTREST_INSTALLER_GIT_URL="https://github.com/cryptrest/installer/archive/$CRYPTREST_INSTALLER_GIT_BRANCH.tar.gz"
CRYPTREST_NAME='cryptrest'
CRYPTREST_TITLE='CryptREST'
CRYPTREST_USER="$USER"
CRYPTREST_DIR="$HOME/.$CRYPTREST_NAME"
CRYPTREST_ENV_FILE="$CRYPTREST_DIR/.env"
CRYPTREST_LIB_DIR="$CRYPTREST_DIR/lib"
CRYPTREST_OPT_DIR="$CRYPTREST_DIR/opt"
CRYPTREST_BIN_DIR="$CRYPTREST_DIR/bin"
CRYPTREST_SRC_DIR="$CRYPTREST_DIR/src"
CRYPTREST_ETC_DIR="$CRYPTREST_DIR/etc"
CRYPTREST_LOG_DIR="$CRYPTREST_DIR/log"
CRYPTREST_WWW_DIR="$CRYPTREST_DIR/www"
CRYPTREST_VAR_DIR="$CRYPTREST_DIR/var"
CRYPTREST_SSL_DIR="$CRYPTREST_DIR/ssl"
CRYPTREST_SSL_CRYPTREST_DIR="$CRYPTREST_SSL_DIR/$CRYPTREST_NAME"
CRYPTREST_TMP_DIR="${TMPDIR:=/tmp}/$CRYPTREST_NAME"
CRYPTREST_MUDULES_LIB_BIN_DIR="$CRYPTREST_LIB_DIR/installer-$CRYPTREST_GIT_BRANCH/bin"
CRYPTREST_MUDULES_LIB_BIN_FILE="$CRYPTREST_MUDULES_LIB_BIN_DIR/modules.sh"

CRYPTREST_MODULES_ARGS="$*"
CRYPTREST_IS_LOCAL=1


cryptrest_init()
{
    mkdir -p "$CRYPTREST_VAR_DIR" && \
    chmod 700 "$CRYPTREST_VAR_DIR" && \
    mkdir -p "$CRYPTREST_OPT_DIR" && \
    chmod 700 "$CRYPTREST_OPT_DIR" && \
    mkdir -p "$CRYPTREST_SRC_DIR" && \
    chmod 700 "$CRYPTREST_SRC_DIR" && \
    mkdir -p "$CRYPTREST_BIN_DIR" && \
    chmod 700 "$CRYPTREST_BIN_DIR" && \
    mkdir -p "$CRYPTREST_ETC_DIR" && \
    chmod 700 "$CRYPTREST_ETC_DIR" && \
    mkdir -p "$CRYPTREST_LOG_DIR" && \
    chmod 700 "$CRYPTREST_LOG_DIR" && \
    mkdir -p "$CRYPTREST_SSL_DIR" && \
    chmod 700 "$CRYPTREST_SSL_DIR" && \
    mkdir -p "$CRYPTREST_SSL_CRYPTREST_DIR" && \
    chmod 700 "$CRYPTREST_SSL_CRYPTREST_DIR" && \
    mkdir -p "$CRYPTREST_TMP_DIR" && \
    chmod 700 "$CRYPTREST_TMP_DIR" && \
    mkdir -p "$CRYPTREST_LIB_DIR" && \
    chmod 700 "$CRYPTREST_LIB_DIR" && \
    mkdir -p "$CRYPTREST_MUDULES_LIB_BIN_DIR" && \
    chmod 700 "$CRYPTREST_MUDULES_LIB_BIN_DIR" && \

    [ -z "$CRYPTREST_MODULES_ARGS" ] && \
    [ -z "$CRYPTREST_MODULES" ] && \
    CRYPTREST_MODULES_ARGS='go'

    echo "$CRYPTREST_TITLE structure: check"
}

cryptrest_modules()
{
    local modules=''

    if [ -z "$CRYPTREST_MODULES_ARGS" ]; then
        modules="$CRYPTREST_MODULES"
    else
        modules="$CRYPTREST_MODULES_ARGS"
    fi

    CRYPTREST_MODULES=''

    for m in $modules; do
        if [ -d "$CRYPTREST_MODULES_DIR/$m" ] && [ -f "$CRYPTREST_MODULES_DIR/$m/install.sh" ]; then
            CRYPTREST_MODULES="$CRYPTREST_MODULES $m"
        else
            echo "$CRYPTREST_TITLE WARNING: module '$m' does not exist"
        fi
    done
}

cryptrest_is_local()
{
    for i in $CRYPTREST_MODULES; do
        if [ -d "$CRYPTREST_MODULES_DIR/$i" ] && [ -f "$CRYPTREST_MODULES_DIR/$i/install.sh" ]; then
            CRYPTREST_IS_LOCAL=0

            break
        fi
    done

    return $CRYPTREST_IS_LOCAL
}

cryptrest_local_install()
{
    echo "$CRYPTREST_TITLE Modules mode: local"
    echo ''

    for m in $CRYPTREST_MODULES; do
        . "$CRYPTREST_MODULES_DIR/$i/install.sh"
        [ $? -ne 0 ] && return 1
    done

    return 0
}

cryptrest_download()
{
    cd "$CRYPTREST_INSTALLER_LIB_BIN_DIR" && \
    curl -SL "$CRYPTREST_INSTALLER_GIT_URL" | tar -xz
    if [ $? -ne 0 ]; then
        echo "$CRYPTREST_TITLE: Some errors with download"
        rm -rf "$CRYPTREST_MUDULES_LIB_BIN_DIR"

        exit 1
    fi
}

cryptrest_network_install()
{
    echo "$CRYPTREST_TITLE mode: network"
    echo ''

    cryptrest_download && \
    CRYPTREST_MODULES="$CRYPTREST_MODULES" "$CRYPTREST_MODULES_BIN_FILE" $CRYPTREST_MODULES_ARGS
}

cryptrest_define()
{
    local profile_file=''

#    chmod 444 "$CRYPTREST_INSTALLER_WWW_HTML_FILE" && \
#    ln -s "$CRYPTREST__COMMON_WWW_ERRORS_DIR/" "$CRYPTREST_INSTALLER_WWW_DIR/" && \
#    chmod 555 "$CRYPTREST_INSTALLER_WWW_DIR" && \
#    chmod 555 "$CRYPTREST_WWW_DIR" && \
#    chmod 400 "$CRYPTREST_ENV_FILE" && \
#    chmod 500 "$CRYPTREST_INSTALLER_LIB_FILE" && \
#    ln -s "$CRYPTREST_INSTALLER_LIB_FILE" "$CRYPTREST_BIN_DIR/cryptrest-installer" && \

    if [ $? -eq 0 ]; then
        echo ''
        echo "$CRYPTREST_TITLE (version: $(cat "$CRYPTREST_INSTALLER_LIB_VERSION_FILE")): installation successfully completed!"
        echo ''
    fi
}

cryptrest_install()
{
    local status=0

    cryptrest_is_local
    if [ $? -eq 0 ]; then
        cryptrest_local_install
        if [ $? -eq 0 ]; then
            status=0

            if [ "$CURRENT_DIR" != "$CRYPTREST_INSTALLER_LIB_DIR" ]; then
#                rm -f "$CRYPTREST_INSTALLER_LIB_DIR/bin.sh" && \
#                cp "$CRYPTREST_MAIN_MODULES_DIR/bin.sh" "$CRYPTREST_INSTALLER_LIB_DIR/bin.sh" && \
                status=$?
            fi
        else
            status=1
        fi
        [ $status -eq 0 ] && cryptrest_define
    else
        cryptrest_network_install
    fi
}


cryptrest_modules && \
cryptrest_init && \
cryptrest_install
