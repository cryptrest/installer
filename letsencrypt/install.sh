#!/bin/sh

CRYPTREST_LETSENCRYPT_GIT_BRANCH="${CRYPTREST_LETSENCRYPT_GIT_BRANCH:=master}"
CRYPTREST_LETSENCRYPT_GIT_URL="https://github.com/letsencrypt/letsencrypt/archive/$CRYPTREST_LETSENCRYPT_GIT_BRANCH.tar.gz"

CRYPTREST_LETSENCRYPT_DIR="$CRYPTREST_OPT_DIR/letsencrypt"
CRYPTREST_LETSENCRYPT_ETC_DIR="$CRYPTREST_ETC_DIR/letsencrypt"
CRYPTREST_LETSENCRYPT_CERTBOT_DIR="$CRYPTREST_LETSENCRYPT_DIR/certbot-$CRYPTREST_LETSENCRYPT_GIT_BRANCH"


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
    cp "$CURRENT_DIR/letsencrypt/"*.conf "$CRYPTREST_LETSENCRYPT_ETC_DIR/" && \
    chmod 400 "$CRYPTREST_LETSENCRYPT_ETC_DIR/"* && \
    cp "$CURRENT_DIR/letsencrypt/"*.sh "$CRYPTREST_LETSENCRYPT_DIR/" && \
    chmod 400 "$CRYPTREST_LETSENCRYPT_DIR/"*.sh && \
    rm -f "$CRYPTREST_LETSENCRYPT_DIR/install"* && \
    chmod 500 "$CRYPTREST_LETSENCRYPT_DIR/renew"* && \
    ln -s "$CRYPTREST_LETSENCRYPT_CERTBOT_DIR/certbot-auto" "$CRYPTREST_BIN_DIR/letsencrypt"
}


echo ''
echo "Let's Encrypt branch: $CRYPTREST_LETSENCRYPT_GIT_BRANCH"
echo "Let's Encrypt URL: $CRYPTREST_LETSENCRYPT_GIT_URL"
echo ''

letsencrypt_prepare && \
letsencrypt_download && \
letsencrypt_install && \
letsencrypt_define
