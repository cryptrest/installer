#!/bin/sh

# Shell utilities: echo, printf, chmod, chown, mkdir,
#                  ln, cp, ls, xargs, cat, exit, cut,
#                  dirname, basename, tr, grep, cd, rm
#
# System utilities: curl, tar, sed, uname


CRYPTREST_CURRENT_DIR="$(cd $(dirname $0) && pwd -P)"

CRYPTREST_CURRENT_ENV_FILE="$CRYPTREST_CURRENT_DIR/.env"
CRYPTREST_MAIN_LIBS_DIR="$CRYPTREST_CURRENT_DIR"
if [ ! -f "$CRYPTREST_CURRENT_ENV_FILE" ]; then
    CRYPTREST_CURRENT_ENV_FILE="$CRYPTREST_CURRENT_DIR/../.env"
    CRYPTREST_MAIN_LIBS_DIR="$CRYPTREST_CURRENT_DIR/.."
elif [ ! -f "$CRYPTREST_CURRENT_ENV_FILE" ]; then
    CRYPTREST_CURRENT_ENV_FILE="$CRYPTREST_CURRENT_DIR/../../.env"
    CRYPTREST_MAIN_LIBS_DIR="$CRYPTREST_CURRENT_DIR/../.."
fi

echo ''
printf 'CryptREST config file: '
if [ -f "$CRYPTREST_CURRENT_ENV_FILE" ]; then
    . "$CRYPTREST_CURRENT_ENV_FILE"
    [ $? -ne 0 ] && return 1

    echo 'loaded'
else
    echo 'not loaded'
fi


CRYPTREST_CURRENT_DIR="$(cd $(dirname $0) && pwd -P)"

CRYPTREST_DOMAIN="${CRYPTREST_DOMAIN:=crypt.rest}"
CRYPTREST_EMAIL="${CRYPTREST_EMAIL:=$CRYPTREST_DOMAIN@gmail.com}"
CRYPTREST_SSL_BIT_SIZE="${CRYPTREST_SSL_BIT_SIZE:=512}"
CRYPTREST_SSL_BIT_KEY_SIZE="${CRYPTREST_SSL_BIT_KEY_SIZE:=4096}"
CRYPTREST_SSL_ECDH_CURVES="${CRYPTREST_SSL_ECDH_CURVES:=secp521r1:brainpoolP512r1:secp384r1:brainpoolP384r1}"
CRYPTREST_INSTALLER_DOMAIN="${CRYPTREST_INSTALLER_DOMAIN:=get}"
CRYPTREST_INSTALLER_GIT_BRANCH="${CRYPTREST_INSTALLER_GIT_BRANCH:=master}"

CRYPTREST_MAIN_LIBS='_common'
CRYPTREST_MAIN_LIBS_LIST=''
CRYPTREST_MAIN_LIBS_BIN_DIR="$CRYPTREST_MAIN_LIBS_DIR/bin"
CRYPTREST_IS_LOCAL=1
CRYPTREST_HOME_SHELL_PROFILE_FILES='.bashrc .mkshrc .zshrc .cshrc .kshrc .rshrc'

CRYPTREST_NAME='cryptrest'
CRYPTREST_TITLE='CryptREST'
CRYPTREST_USER="$USER"
CRYPTREST_DIR="$HOME/.$CRYPTREST_NAME"
CRYPTREST_ENV_FILE="$CRYPTREST_DIR/.env"
CRYPTREST_LIB_DIR="$CRYPTREST_DIR/lib"
CRYPTREST_OPT_DIR="$CRYPTREST_DIR/opt"
CRYPTREST_BIN_DIR="$CRYPTREST_DIR/bin"
CRYPTREST_SRC_DIR="$CRYPTREST_DIR/src"
CRYPTREST_WWW_DIR="$CRYPTREST_DIR/www"
CRYPTREST_VAR_DIR="$CRYPTREST_DIR/var"
CRYPTREST_VAR_LOG_DIR="$CRYPTREST_VAR_DIR/log"
CRYPTREST_VAR_RUN_DIR="$CRYPTREST_VAR_DIR/run"
CRYPTREST_ETC_DIR="$CRYPTREST_DIR/etc"
CRYPTREST_ETC_SSL_DIR="$CRYPTREST_ETC_DIR/ssl"
CRYPTREST_ETC_DOMAINS_DIR="$CRYPTREST_ETC_DIR/.domains"
CRYPTREST_TMP_DIR="${TMPDIR:=/tmp}/$CRYPTREST_NAME"

CRYPTREST_INSTALLER_NAME='installer'
CRYPTREST_INSTALLER_GIT_URL="https://github.com/$CRYPTREST_NAME/$CRYPTREST_INSTALLER_NAME/archive/$CRYPTREST_INSTALLER_GIT_BRANCH.tar.gz"
CRYPTREST_INSTALLER_BIN_FILE="$CRYPTREST_BIN_DIR/$CRYPTREST_NAME-$CRYPTREST_INSTALLER_NAME"
CRYPTREST_INSTALLER_LIB_DIR="$CRYPTREST_LIB_DIR/$CRYPTREST_INSTALLER_NAME-$CRYPTREST_INSTALLER_GIT_BRANCH"
CRYPTREST_INSTALLER_LIB_BIN_DIR="$CRYPTREST_INSTALLER_LIB_DIR/bin"
CRYPTREST_INSTALLER_LIB_FILE="$CRYPTREST_INSTALLER_LIB_DIR/bin.sh"
CRYPTREST_INSTALLER_LIB_VERSION_FILE="$CRYPTREST_INSTALLER_LIB_DIR/VERSION"
CRYPTREST_INSTALLER_WWW_DIR="$CRYPTREST_WWW_DIR/$CRYPTREST_INSTALLER_DOMAIN"
CRYPTREST_INSTALLER_WWW_HTML_FILE="$CRYPTREST_INSTALLER_WWW_DIR/index.html"
CRYPTREST_INSTALLER_WWW_ROBOTSTXT_FILE="$CRYPTREST_INSTALLER_WWW_DIR/robots.txt"
CRYPTREST_INSTALLER_IS_SITE=''
CRYPTREST_INSTALLER_SITE='site'
CRYPTREST_INSTALLER_ARGS="$*"


cryptrest_utilities_check()
{
    local utils_list='curl tar sed uname'

    for u in $utils_list; do
        "$u" --version 1> /dev/null
        if [ $? -ne 0 ]; then
            echo "$CRYPTREST_TITLE check: '$u' not found or installed"
            echo ''

            exit 1
        fi
    done
}

cryptrest_prepare()
{
(   if [ -d ""$CRYPTREST_WWW_DIR"" ]; then
        chmod 700 "$CRYPTREST_WWW_DIR"
    fi

    if [ -d ""$CRYPTREST_INSTALLER_WWW_DIR"" ]; then
        chmod 700 "$CRYPTREST_INSTALLER_WWW_DIR" && \
        for d in $(ls "$CRYPTREST_INSTALLER_WWW_DIR/"); do
            [ -d "$CRYPTREST_INSTALLER_WWW_DIR/$d" ] && \
            chmod -R 700 "$CRYPTREST_INSTALLER_WWW_DIR/$d" && \
            rm -rf "$CRYPTREST_INSTALLER_WWW_DIR/$d"
        done
        rm -rf "$CRYPTREST_INSTALLER_WWW_DIR"
    fi) && \

    rm -f "$CRYPTREST_ENV_FILE" && \
    rm -f "$CRYPTREST_INSTALLER_BIN_FILE"
}

cryptrest_init()
{
    cryptrest_prepare && \
    mkdir -p "$CRYPTREST_DIR" && \
    chmod 755 "$CRYPTREST_DIR" && \
    mkdir -p "$CRYPTREST_OPT_DIR" && \
    chmod 700 "$CRYPTREST_OPT_DIR" && \
    mkdir -p "$CRYPTREST_SRC_DIR" && \
    chmod 700 "$CRYPTREST_SRC_DIR" && \
    mkdir -p "$CRYPTREST_BIN_DIR" && \
    chmod 700 "$CRYPTREST_BIN_DIR" && \
    mkdir -p "$CRYPTREST_ETC_DIR" && \
    chmod 700 "$CRYPTREST_ETC_DIR" && \
    mkdir -p "$CRYPTREST_WWW_DIR" && \
    chmod 700 "$CRYPTREST_WWW_DIR" && \
    mkdir -p "$CRYPTREST_TMP_DIR" && \
    chmod 700 "$CRYPTREST_TMP_DIR" && \
    mkdir -p "$CRYPTREST_LIB_DIR" && \
    chmod 700 "$CRYPTREST_LIB_DIR" && \
    mkdir -p "$CRYPTREST_VAR_DIR" && \
    chmod 700 "$CRYPTREST_VAR_DIR" && \
    mkdir -p "$CRYPTREST_VAR_LOG_DIR" && \
    chmod 700 "$CRYPTREST_VAR_LOG_DIR" && \
    mkdir -p "$CRYPTREST_VAR_RUN_DIR" && \
    chmod 700 "$CRYPTREST_VAR_RUN_DIR" && \
    mkdir -p "$CRYPTREST_INSTALLER_LIB_DIR" && \
    chmod 700 "$CRYPTREST_INSTALLER_LIB_DIR" && \
    mkdir -p "$CRYPTREST_INSTALLER_WWW_DIR" && \
    chmod 700 "$CRYPTREST_INSTALLER_WWW_DIR" && \
    mkdir -p "$CRYPTREST_ETC_SSL_DIR" && \
    chmod 700 "$CRYPTREST_ETC_SSL_DIR" && \
    mkdir -p "$CRYPTREST_ETC_DOMAINS_DIR" && \
    chmod 700 "$CRYPTREST_ETC_DOMAINS_DIR" && \
    echo '' > "$CRYPTREST_ENV_FILE" && \
    chmod 600 "$CRYPTREST_ENV_FILE" && (

    echo "# $CRYPTREST_TITLE" > "$CRYPTREST_ENV_FILE"
    echo "export CRYPTREST_DIR=\"$HOME/.$CRYPTREST_NAME\"" >> "$CRYPTREST_ENV_FILE"
    echo "export PATH=\"\$CRYPTREST_DIR/bin:\$PATH\"" >> "$CRYPTREST_ENV_FILE"
    echo '' >> "$CRYPTREST_ENV_FILE"
    echo "CRYPTREST_USER=\"$CRYPTREST_USER\"" >> "$CRYPTREST_ENV_FILE"
    echo "CRYPTREST_EMAIL=\"$CRYPTREST_EMAIL\"" >> "$CRYPTREST_ENV_FILE"
    echo "CRYPTREST_DOMAIN=\"$CRYPTREST_DOMAIN\"" >> "$CRYPTREST_ENV_FILE"
    echo "CRYPTREST_SSL_BIT_SIZE=\"$CRYPTREST_SSL_BIT_SIZE\"" >> "$CRYPTREST_ENV_FILE"
    echo "CRYPTREST_SSL_BIT_KEY_SIZE=\"$CRYPTREST_SSL_BIT_KEY_SIZE\"" >> "$CRYPTREST_ENV_FILE"
    echo "CRYPTREST_SSL_ECDH_CURVES=\"$CRYPTREST_SSL_ECDH_CURVES\"" >> "$CRYPTREST_ENV_FILE"

    echo "$CRYPTREST_TITLE structure: init")
}

cryptrest_is_local()
{
    for i in $CRYPTREST_MAIN_LIBS; do
        if [ -d "$CRYPTREST_MAIN_LIBS_DIR/$i" ] && [ -f "$CRYPTREST_MAIN_LIBS_DIR/$i/install.sh" ]; then
            CRYPTREST_IS_LOCAL=0

            break
        fi
    done

    return $CRYPTREST_IS_LOCAL
}

cryptrest_local_install()
{
    echo "$CRYPTREST_TITLE mode: local"
    echo ''

    for i in $CRYPTREST_MAIN_LIBS; do
        . "$CRYPTREST_MAIN_LIBS_DIR/$i/install.sh"

        [ $? -ne 0 ] && return 1
    done

    cp "$CRYPTREST_MAIN_LIBS_DIR/bin.sh" "$CRYPTREST_INSTALLER_WWW_HTML_FILE" && \
    return 0
}

cryptrest_download()
{
    cd "$CRYPTREST_LIB_DIR" && \
    curl -SL "$CRYPTREST_INSTALLER_GIT_URL" | tar -xz
    if [ $? -ne 0 ]; then
        echo "$CRYPTREST_TITLE: Some errors with installer downloading"
        rm -rf "$CRYPTREST_DIR"

        exit 1
    fi
}

cryptrest_network_install()
{
    echo "$CRYPTREST_TITLE mode: network"
    echo ''

    cryptrest_download && \
    cp "$CRYPTREST_INSTALLER_LIB_FILE" "$CRYPTREST_INSTALLER_WWW_HTML_FILE" && \
    "$CRYPTREST_INSTALLER_LIB_FILE" $CRYPTREST_INSTALLER_ARGS
}

cryptrest_define()
{
    cryptrest_bin_installer_define && \
    ln -s "$CRYPTREST__COMMON_WWW_HTML_ERRORS_DIR/" "$CRYPTREST_INSTALLER_WWW_DIR/" && \
    ln -s "$CRYPTREST__COMMON_WWW_ASSETS_DIR/" "$CRYPTREST_INSTALLER_WWW_DIR/" && \
    ln -s "$CRYPTREST__COMMON_WWW_ASSETS_ICONS_DIR/"* "$CRYPTREST_INSTALLER_WWW_DIR/" && \
    cp "$CRYPTREST_INSTALLER_LIB_FILE" "$CRYPTREST_INSTALLER_WWW_DIR/index.html" && \
    chmod 444 "$CRYPTREST_INSTALLER_WWW_DIR/index.html" && \
    chmod 400 "$CRYPTREST_ENV_FILE" && \
    chmod 500 "$CRYPTREST_INSTALLER_LIB_FILE" && \
    ln -s "$CRYPTREST_INSTALLER_LIB_FILE" "$CRYPTREST_INSTALLER_BIN_FILE" && \
    cryptrest_robotstxt_installer && \
    chmod 555 "$CRYPTREST_INSTALLER_WWW_DIR" && \
    chmod 555 "$CRYPTREST_WWW_DIR"
}

cryptrest_version_define()
{
    local version=''
    local message=''

    if [ -f "$CRYPTREST_INSTALLER_LIB_VERSION_FILE" ]; then
        version="$(cat "$CRYPTREST_INSTALLER_LIB_VERSION_FILE")"
        message=" (version: $version)"
    fi

    echo "$message"
}

cryptrest_profile_file_autoclean()
{
    local profile_file="$1"
    local file_backup="$profile_file.backup"

    cp "$profile_file" "$file_backup"
    [ -f "$file_backup" ] && \
    grep -v '[Cc][Rr][Yy][Pp][Tt][Rr][Ee][Ss][Tt]' "$file_backup" | cat -s > "$profile_file" && \
    rm -f "$file_backup"
}

cryptrest_define_env_file()
{
    local profile_file=''

    if [ $? -eq 0 ]; then
        echo ''
        echo "$CRYPTREST_TITLE ENV added in following profile file(s):"

        for shell_profile_file in $CRYPTREST_HOME_SHELL_PROFILE_FILES; do
            profile_file="$HOME/$shell_profile_file"

            if [ -f "$profile_file" ]; then
                cryptrest_profile_file_autoclean "$profile_file"

                echo '' >> "$profile_file"
                echo "# $CRYPTREST_TITLE" >> "$profile_file"
                echo ". \$HOME/.$CRYPTREST_NAME/.env" >> "$profile_file"

                echo "    '$profile_file"
            fi
        done

        echo ''
        echo "$CRYPTREST_TITLE$(cryptrest_version_define): installation successfully completed!"
        echo ''
    fi
}

cryptrest_bin_installer_define()
{
    local html_file=''
    local html_dir=''
    local bin_file=''
    local file_name=''

    [ -d "$CRYPTREST_INSTALLER_LIB_BIN_DIR" ] && \
    [ ! -z "$(ls "$CRYPTREST_INSTALLER_LIB_BIN_DIR")" ] && \
    chmod 700 "$CRYPTREST_INSTALLER_LIB_BIN_DIR/"*.sh

    mkdir -p "$CRYPTREST_INSTALLER_LIB_BIN_DIR" && \
    chmod 700 "$CRYPTREST_INSTALLER_LIB_BIN_DIR" && \
    rm -f "$CRYPTREST_INSTALLER_BIN_FILE"* && \

    for f in $(ls "$CRYPTREST_MAIN_LIBS_BIN_DIR/"*.sh); do
        CRYPTREST_MAIN_LIBS_LIST="$CRYPTREST_MAIN_LIBS_LIST $f"

        [ "$f" = 'structure' ] && continue

        file_name="$(basename -s .sh "$f")"
        html_dir="$CRYPTREST_INSTALLER_WWW_DIR/$file_name"
        html_file="$html_dir/index.html"
        bin_file="$CRYPTREST_INSTALLER_LIB_BIN_DIR/$(basename "$f")"

        if [ "$f" != "$bin_file" ]; then
            cp "$f" "$bin_file" && \
            chmod 500 "$bin_file"
        fi

        mkdir -p "$html_dir" && \
        cp "$bin_file" "$html_file" && \
        chmod 444 "$html_file" && \
        chmod 555 "$html_dir" && \
        ln -s "$bin_file" "$CRYPTREST_INSTALLER_BIN_FILE-$file_name"
    done
}

cryptrest_robotstxt_installer()
{
(   echo "# $CRYPTREST_TITLE Installer" > "$CRYPTREST_INSTALLER_WWW_ROBOTSTXT_FILE"
    echo 'User-agent: *' >> "$CRYPTREST_INSTALLER_WWW_ROBOTSTXT_FILE"
    echo 'Disallow: /' >> "$CRYPTREST_INSTALLER_WWW_ROBOTSTXT_FILE"
    echo 'Allow: /' >> "$CRYPTREST_INSTALLER_WWW_ROBOTSTXT_FILE"

    for l in $CRYPTREST_MAIN_LIBS_LIST; do
        echo "Allow: /$l" >> "$CRYPTREST_INSTALLER_WWW_ROBOTSTXT_FILE"
    done

    chmod 444 "$CRYPTREST_INSTALLER_WWW_ROBOTSTXT_FILE") && \

    echo "$CRYPTREST_TITLE Installer robots.txt file: init"
}

cryptrest_installer_site_difine()
{
    for var in $CRYPTREST_INSTALLER_ARGS; do
        if []; then
            CRYPTREST_INSTALLER_IS_SITE="$CRYPTREST_INSTALLER_SITE"

            break
        fi
    done
}

cryptrest_domains_installer()
{
    cryptrest_installer_site_difine

    if [ "$CRYPTREST_INSTALLER_IS_SITE" = "$CRYPTREST_INSTALLER_SITE" ]; then
        echo "CRYPTREST_LIB_DOMAIN=\"$CRYPTREST_INSTALLER_DOMAIN.\$CRYPTREST_DOMAIN\"" > "$CRYPTREST_ETC_DOMAINS_DIR/$CRYPTREST_INSTALLER_DOMAIN"
        echo "CRYPTREST_DOMAINS=\"$CRYPTREST_INSTALLER_DOMAIN.\$CRYPTREST_DOMAIN\"" >> "$CRYPTREST_ETC_DOMAINS_DIR/$CRYPTREST_INSTALLER_DOMAIN"
    else
        rm -f "$CRYPTREST_ETC_DOMAINS_DIR/$CRYPTREST_INSTALLER_DOMAIN"
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

            if [ "$CRYPTREST_CURRENT_DIR" != "$CRYPTREST_INSTALLER_LIB_DIR" ]; then
                rm -f "$CRYPTREST_INSTALLER_LIB_FILE" && \
                cp "$CRYPTREST_MAIN_LIBS_DIR/bin.sh" "$CRYPTREST_INSTALLER_LIB_FILE" && \
                cp "$CRYPTREST_MAIN_LIBS_DIR/VERSION" "$CRYPTREST_INSTALLER_LIB_VERSION_FILE" && \
                cp "$CRYPTREST_MAIN_LIBS_DIR/README"* "$CRYPTREST_INSTALLER_LIB_DIR/" && \

                status=$?
            fi
        else
            status=1
        fi

        [ $status -eq 0 ] && \
        cryptrest_define && \
        cryptrest_define_env_file && \
        cryptrest_domains_installer
    else
        cryptrest_network_install
    fi
}


cryptrest_utilities_check && \
cryptrest_init && \
cryptrest_install
