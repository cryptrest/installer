#!/bin/sh

CRYPTREST_LETSENCRYPT_GIT_BRANCH="${CRYPTREST_LETSENCRYPT_GIT_BRANCH:=master}"
CRYPTREST_LETSENCRYPT_GIT_URL="https://github.com/letsencrypt/letsencrypt/archive/$CRYPTREST_LETSENCRYPT_GIT_BRANCH.tar.gz"

CRYPTREST_LETSENCRYPT_DIR="$CRYPTREST_OPT_DIR/letsencrypt"
CRYPTREST_LETSENCRYPT_ETC_DIR="$CRYPTREST_ETC_DIR/letsencrypt"
CRYPTREST_LETSENCRYPT_CERTBOT_DIR="$CRYPTREST_LETSENCRYPT_DIR/certbot-$CRYPTREST_LETSENCRYPT_GIT_BRANCH"

CRYPTREST_LETSENCRYPT_URL='https://letsencrypt.org/certs/'
CRYPTREST_LETSENCRYPT_PEM_FILES='lets-encrypt-x4-cross-signed.pem lets-encrypt-x3-cross-signed.pem isrgrootx1.pem'
CRYPTREST_LETSENCRYPT_BITS='256'
CRYPTREST_LETSENCRYPT_TITLE="Let's Encrypt"

case "$(uname -m)" in
    x86_64 | amd64 )
        CRYPTREST_LETSENCRYPT_ARCH='amd64'
    ;;
    x86 | i386 | i486 | i586 | i686 | i786 )
        CRYPTREST_LETSENCRYPT_ARCH='386'
    ;;
    * )
        echo "ERROR: Current OS architecture has not been supported for $CRYPTREST_LETSENCRYPT_TITLE"

        exit 1
    ;;
esac

case "$(uname -s)" in
    Linux )
        CRYPTREST_LETSENCRYPT_OS='linux'
        CRYPTREST_LETSENCRYPT_ETC_SYS_DIR='/etc/letsencrypt/live'
    ;;
    Darwin )
        CRYPTREST_NGINX_OS='darwin'
        CRYPTREST_LETSENCRYPT_ETC_SYS_DIR='/usr/local/etc/letsencrypt/live'
    ;;
    FreeBSD )
        CRYPTREST_NGINX_OS="freebsd"
        CRYPTREST_LETSENCRYPT_ETC_SYS_DIR='/usr/local/etc/letsencrypt/live'
    ;;
    * )
        echo "ERROR: Current OS does not supported for $CRYPTREST_LETSENCRYPT_TITLE"

        exit 1
    ;;
esac


letsencrypt_prepare()
{
    rm -rf "$CRYPTREST_LETSENCRYPT_DIR" && \
    rm -rf "$CRYPTREST_LETSENCRYPT_CERTBOT_DIR" && \
    rm -rf "$CRYPTREST_LETSENCRYPT_ETC_DIR/" && \
    [ -d "$CRYPTREST_BIN_DIR/" ] && \
    rm -f "$CRYPTREST_BIN_DIR/letsencrypt"*
}

letsencrypt_download()
{
    mkdir -p "$CRYPTREST_LETSENCRYPT_DIR" && \
    cd "$CRYPTREST_LETSENCRYPT_DIR" && \
    curl -SL "$CRYPTREST_LETSENCRYPT_GIT_URL" | tar -xz
    if [ $? -ne 0 ]; then
        echo "Some error with download"
        rm -rf "$CRYPTREST_LETSENCRYPT_DIR"

        exit 1
    fi
}

letsencrypt_install()
{
    chmod 700 "$CRYPTREST_LETSENCRYPT_CERTBOT_DIR" && \
    chmod 700 "$CRYPTREST_LETSENCRYPT_DIR" && \
    mkdir -p "$CRYPTREST_LETSENCRYPT_ETC_DIR" && \
    chmod 700 "$CRYPTREST_LETSENCRYPT_ETC_DIR"
}

letsencrypt_define()
{
    cp "$CRYPTREST_MODULES_DIR/letsencrypt/etc/"*.conf "$CRYPTREST_LETSENCRYPT_ETC_DIR/" && \
    chmod 400 "$CRYPTREST_LETSENCRYPT_ETC_DIR/"* && \
    cp "$CRYPTREST_MODULES_DIR/letsencrypt/opt/"*.sh "$CRYPTREST_LETSENCRYPT_DIR/" && \
    chmod 400 "$CRYPTREST_LETSENCRYPT_DIR/"*.sh && \
    rm -f "$CRYPTREST_LETSENCRYPT_DIR/install"* && \
    ln -s "$CRYPTREST_LETSENCRYPT_CERTBOT_DIR/certbot-auto" "$CRYPTREST_BIN_DIR/letsencrypt" && \

    echo "# $CRYPTREST_LETSENCRYPT_TITLE" >> "$CRYPTREST_ENV_FILE"
    echo "CRYPTREST_LETSENCRYPT_ETC_SYS_DIR=\"$CRYPTREST_LETSENCRYPT_ETC_SYS_DIR\"" >> "$CRYPTREST_ENV_FILE"
    echo "CRYPTREST_LETSENCRYPT_URL=\"$CRYPTREST_LETSENCRYPT_URL\"" >> "$CRYPTREST_ENV_FILE"
    echo "CRYPTREST_LETSENCRYPT_PEM_FILES=\"$CRYPTREST_LETSENCRYPT_PEM_FILES\"" >> "$CRYPTREST_ENV_FILE"
    echo "CRYPTREST_LETSENCRYPT_BITS=\"$CRYPTREST_LETSENCRYPT_BITS\"" >> "$CRYPTREST_ENV_FILE"
    echo "CRYPTREST_LETSENCRYPT_ARCH=\"$CRYPTREST_LETSENCRYPT_ARCH\"" >> "$CRYPTREST_ENV_FILE"
    echo "CRYPTREST_LETSENCRYPT_OS=\"$CRYPTREST_LETSENCRYPT_OS\"" >> "$CRYPTREST_ENV_FILE"
    echo '' >> "$CRYPTREST_ENV_FILE"
    echo '' >> "$CRYPTREST_ENV_FILE"

    echo ''
    echo "CRYPTREST_LETSENCRYPT_* variables added in '$CRYPTREST_ENV_FILE'"
    echo ''
}


echo ''
echo "$CRYPTREST_LETSENCRYPT_TITLE branch: $CRYPTREST_LETSENCRYPT_GIT_BRANCH"
echo "$CRYPTREST_LETSENCRYPT_TITLE URL: $CRYPTREST_LETSENCRYPT_GIT_URL"
echo ''

letsencrypt_prepare && \
letsencrypt_download && \
letsencrypt_install && \
letsencrypt_define
