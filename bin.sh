#!/bin/sh

CURRENT_DIR="$(cd $(dirname $0) && pwd -P)"

if [ -f "$CURRENT_DIR/.env" ]; then
    . "$CURRENT_DIR/.env"

    echo ''
    echo 'CryptREST: config file loaded'
fi

CURRENT_DIR="$(cd $(dirname $0) && pwd -P)"

CRYPTREST_DOMAIN="${CRYPTREST_DOMAIN:=crypt.rest}"
CRYPTREST_DOMAINS="${CRYPTREST_DOMAINS:=$CRYPTREST_DOMAIN api.$CRYPTREST_DOMAIN installer.$CRYPTREST_DOMAIN}"
CRYPTREST_EMAIL="${CRYPTREST_EMAIL:=$CRYPTREST_DOMAIN@gmail.com}"
CRYPTREST_SSL_KEY_SIZE="${CRYPTREST_SSL_KEY_SIZE:=4096}"
CRYPTREST_GIT_BRANCH="${CRYPTREST_GIT_BRANCH:=master}"

CRYPTREST_GIT_URL="https://github.com/cryptrest/installer/archive/$CRYPTREST_GIT_BRANCH.tar.gz"
CRYPTREST_TITLE='CryptREST'
CRYPTREST_USER="$USER"
CRYPTREST_DIR="$HOME/.cryptrest"
CRYPTREST_ENV_FILE="$CRYPTREST_DIR/.env"
CRYPTREST_LIB_DIR="$CRYPTREST_DIR/lib"
CRYPTREST_OPT_DIR="$CRYPTREST_DIR/opt"
CRYPTREST_BIN_DIR="$CRYPTREST_DIR/bin"
CRYPTREST_SRC_DIR="$CRYPTREST_DIR/src"
CRYPTREST_ETC_DIR="$CRYPTREST_DIR/etc"
CRYPTREST_LOG_DIR="$CRYPTREST_DIR/log"
CRYPTREST_WWW_DIR="$CRYPTREST_DIR/www"
CRYPTREST_TMP_DIR="${TMPDIR:=/tmp}/cryptrest"
CRYPTREST_LIB_INSTALLER_DIR="$CRYPTREST_LIB_DIR/installer-$CRYPTREST_GIT_BRANCH"
CRYPTREST_LIB_INSTALLER_FILE="$CRYPTREST_LIB_INSTALLER_DIR/bin.sh"
CRYPTREST_LIB_INSTALLER_VERSION_FILE="$CRYPTREST_LIB_INSTALLER_DIR/VERSION"
CRYPTREST_WWW_INSTALLER_DIR="$CRYPTREST_WWW_DIR/installer"
CRYPTREST_WWW_INSTALLER_HTML_FILE="$CRYPTREST_WWW_INSTALLER_DIR/index.html"

CRYPTREST_MODULES='_common nginx letsencrypt go'
CRYPTREST_IS_LOCAL=1
CRYPTREST_HOME_SHELL_PROFILE_FILES=".bashrc .mkshrc .zshrc"


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
    if [ -d ""$CRYPTREST_WWW_DIR"" ]; then
        chmod 700 "$CRYPTREST_WWW_DIR"
    fi
    if [ -d ""$CRYPTREST_WWW_INSTALLER_DIR"" ]; then
        chmod 700 "$CRYPTREST_WWW_INSTALLER_DIR" && \
        rm -rf "$CRYPTREST_WWW_INSTALLER_DIR"
    fi

    rm -f "$CRYPTREST_ENV_FILE" && \
    rm -f "$CRYPTREST_BIN_DIR/cryptrest-in"* && \
    mkdir -p "$CRYPTREST_DIR" && \
    chmod 755 "$CRYPTREST_DIR" && \
    mkdir -p "$CRYPTREST_LIB_DIR" && \
    chmod 700 "$CRYPTREST_LIB_DIR" && \
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
    mkdir -p "$CRYPTREST_WWW_DIR" && \
    chmod 700 "$CRYPTREST_WWW_DIR" && \
    mkdir -p "$CRYPTREST_WWW_INSTALLER_DIR" && \
    chmod 700 "$CRYPTREST_WWW_INSTALLER_DIR" && \
    mkdir -p "$CRYPTREST_TMP_DIR" && \
    chmod 700 "$CRYPTREST_TMP_DIR" && \
    mkdir -p "$CRYPTREST_LIB_INSTALLER_DIR" && \
    chmod 700 "$CRYPTREST_LIB_INSTALLER_DIR" && \
    echo '' > "$CRYPTREST_ENV_FILE" && \
    chmod 600 "$CRYPTREST_ENV_FILE" && \
    echo "# $CRYPTREST_TITLE" > "$CRYPTREST_ENV_FILE"
    echo "export CRYPTREST_DIR=\"$HOME/.cryptrest\"" >> "$CRYPTREST_ENV_FILE"
    echo "export PATH=\"\$PATH:\$CRYPTREST_DIR/bin\"" >> "$CRYPTREST_ENV_FILE"
    echo '' >> "$CRYPTREST_ENV_FILE"
    echo "CRYPTREST_USER=\"$CRYPTREST_USER\"" >> "$CRYPTREST_ENV_FILE"
    echo "CRYPTREST_DOMAIN=\"$CRYPTREST_DOMAIN\"" >> "$CRYPTREST_ENV_FILE"
    echo "CRYPTREST_DOMAINS=\"$CRYPTREST_DOMAINS\"" >> "$CRYPTREST_ENV_FILE"
    echo "CRYPTREST_EMAIL=\"$CRYPTREST_EMAIL\"" >> "$CRYPTREST_ENV_FILE"
    echo "CRYPTREST_SSL_KEY_SIZE=\"$CRYPTREST_SSL_KEY_SIZE\"" >> "$CRYPTREST_ENV_FILE"
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
        [ $? -ne 0 ] && return 1
    done

    cp "$CURRENT_DIR/bin.sh" "$CRYPTREST_WWW_INSTALLER_HTML_FILE" && \
    return 0
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
    cp "$CRYPTREST_LIB_INSTALLER_FILE" "$CRYPTREST_WWW_INSTALLER_HTML_FILE" && \
    "$CRYPTREST_LIB_INSTALLER_FILE"
}

cryptrest_define()
{
    local profile_file=''

    chmod 444 "$CRYPTREST_WWW_INSTALLER_HTML_FILE" && \
    ln -s "$CRYPTREST__COMMON_WWW_ERRORS_DIR/" "$CRYPTREST_WWW_INSTALLER_DIR/" && \
    chmod 555 "$CRYPTREST_WWW_INSTALLER_DIR" && \
    chmod 555 "$CRYPTREST_WWW_DIR" && \
    chmod 400 "$CRYPTREST_ENV_FILE" && \
    chmod 500 "$CRYPTREST_LIB_INSTALLER_FILE" && \
    ln -s "$CRYPTREST_LIB_INSTALLER_FILE" "$CRYPTREST_BIN_DIR/cryptrest-installer" && \

    if [ $? -eq 0 ]; then
        echo ''
        echo "$CRYPTREST_TITLE ENV added in following profile file(s):"

        for shell_profile_file in $CRYPTREST_HOME_SHELL_PROFILE_FILES; do
            profile_file="$HOME/$shell_profile_file"

            if [ -f "$profile_file" ]; then
                echo '' >> "$profile_file"
                echo "# $CRYPTREST_TITLE" >> "$profile_file"
                echo ". \$HOME/.cryptrest/.env" >> "$profile_file"

               echo "    '$profile_file"
            fi
        done

        echo ''
        echo "$CRYPTREST_TITLE installation successfully completed!"
        echo ''
    fi
}

cryptrest_install()
{
    local status=0

    cryptrest_is_local
    if [ $? -eq 0 ]; then
        cryptrest_local && \
        if [ $? -eq 0 ]; then
            status=0

            if [ "$CURRENT_DIR" != "$CRYPTREST_LIB_INSTALLER_DIR" ]; then
                rm -f "$CRYPTREST_LIB_INSTALLER_DIR/bin.sh" && \
                cp "$CURRENT_DIR/bin.sh" "$CRYPTREST_LIB_INSTALLER_DIR/bin.sh" && \
                cp "$CURRENT_DIR/VERSION" "$CRYPTREST_LIB_INSTALLER_VERSION_FILE" && \
                cp "$CURRENT_DIR/README"* "$CRYPTREST_LIB_INSTALLER_DIR/" && \
                status=$?
            fi
        else
            status=1
        fi
        [ $status -eq 0 ] && cryptrest_define
    else
        cryptrest_network
    fi
}


cryptrest_init && \
cryptrest_install
