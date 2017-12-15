#!/bin/sh

CURRENT_DIR="$(cd $(dirname $0) && pwd -P)"

CRYPTREST_LETSENCRYPT_BRANCH='master'
CRYPTREST_LETSENCRYPT_DIR="${HOME}/.letsencrypt"
CRYPTREST_LETSENCRYPT_PATH="${HOME}/letsencrypt"
CRYPTREST_LETSENCRYPT_URL="https://github.com/letsencrypt/letsencrypt/archive/${CRYPTREST_LETSENCRYPT_BRANCH}.tar.gz"


letsencrypt_prepare()
{
    rm -rf "$CRYPTREST_LETSENCRYPT_DIR"
    rm -rf "$CRYPTREST_LETSENCRYPT_PATH"
}

letsencrypt_download()
{
    mkdir -p "$CRYPTREST_LETSENCRYPT_DIR" && \
    cd "$CRYPTREST_LETSENCRYPT_DIR" && \
    curl -SL "$CRYPTREST_LETSENCRYPT_URL" | tar -xz
    if [ $? -ne 0 ]; then
        echo "Some error with download"
        rm -rf "$CRYPTREST_LETSENCRYPT_DIR"

        exit 1
    fi
}

letsencrypt_install()
{
    mv "$CRYPTREST_LETSENCRYPT_DIR/certbot-$CRYPTREST_LETSENCRYPT_BRANCH" "$CRYPTREST_LETSENCRYPT_DIR/certbot" && \
    chmod 700 "$CRYPTREST_LETSENCRYPT_DIR" && \
    mkdir -p "$CRYPTREST_LETSENCRYPT_PATH" && \
    chmod 700 "$CRYPTREST_LETSENCRYPT_PATH"
}

letsencrypt_define()
{
    cp "$CURRENT_DIR/"*.sh "$CRYPTREST_LETSENCRYPT_PATH" && \
    cp "$CURRENT_DIR/"*.conf "$CRYPTREST_LETSENCRYPT_PATH" && \
    chmod 400 "$CRYPTREST_LETSENCRYPT_PATH/"* && \
    rm -f "$CRYPTREST_LETSENCRYPT_PATH/$(basename $0)" && \
    chmod 700 "$CRYPTREST_LETSENCRYPT_PATH/renew"*
}


echo ''
echo "Let's Encrypt branch: $CRYPTREST_LETSENCRYPT_BRANCH"
echo "Let's Encrypt URL: $CRYPTREST_LETSENCRYPT_URL"
echo ''

letsencrypt_prepare && \
letsencrypt_download && \
letsencrypt_install && \
letsencrypt_define
