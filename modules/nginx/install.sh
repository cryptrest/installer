#!/bin/sh

CRYPTREST_NGINX_OPT_DIR="$CRYPTREST_OPT_DIR/nginx"
CRYPTREST_NGINX_ETC_DIR="$CRYPTREST_ETC_DIR/nginx"
CRYPTREST_NGINX_LOG_DIR="$CRYPTREST_LOG_DIR/nginx"
CRYPTREST_NGINX_TITLE='NGinx'
CRYPTREST_NGINX_BIN_LETSENCRYPT_INIT_FILE="$CRYPTREST_BIN_DIR/cryptrest-nginx-letsencrypt-init"
CRYPTREST_NGINX_BIN_OPENSSL_INIT_FILE="$CRYPTREST_BIN_DIR/cryptrest-nginx-openssl-init"
CRYPTREST_NGINX_BIN_INIT_FILE="$CRYPTREST_BIN_DIR/cryptrest-nginx-init"

case "$(uname -m)" in
    x86_64 | amd64 )
        CRYPTREST_NGINX_ARCH='amd64'
    ;;
    x86 | i386 | i486 | i586 | i686 | i786 )
        CRYPTREST_NGINX_ARCH='386'
    ;;
    * )
        echo "ERROR: Current OS architecture has not been supported for NGinx"

        exit 1
    ;;
esac

case "$(uname -s)" in
    Linux )
        CRYPTREST_NGINX_OS='linux'
        CRYPTREST_NGINX_CMD_START='systemctl start nginx'
        CRYPTREST_NGINX_CMD_STOP='systemctl stop nginx'
    ;;
    Darwin )
        CRYPTREST_NGINX_OS='darwin'
        CRYPTREST_NGINX_CMD_START='brew services start nginx'
        CRYPTREST_NGINX_CMD_STOP='brew services stop nginx'
    ;;
    FreeBSD )
        CRYPTREST_NGINX_OS="freebsd"
        CRYPTREST_NGINX_CMD_START='service nginx start'
        CRYPTREST_NGINX_CMD_STOP='service nginx stop'
    ;;
    * )
        echo "ERROR: Current OS does not supported for $CRYPTREST_NGINX_TITLE"

        exit 1
    ;;
esac


nginx_prepare()
{
    rm -f "$CRYPTREST_BIN_DIR/cryptrest-nginx"* && \
    rm -rf "$CRYPTREST_NGINX_ETC_DIR" && \
    rm -rf "$CRYPTREST_NGINX_LOG_DIR" && \
    rm -rf "$CRYPTREST_NGINX_OPT_DIR"
}

nginx_install()
{
    mkdir -p "$CRYPTREST_NGINX_ETC_DIR" && \
    chmod 700 "$CRYPTREST_NGINX_ETC_DIR" && \
    mkdir -p "$CRYPTREST_NGINX_LOG_DIR" && \
    chmod 700 "$CRYPTREST_NGINX_LOG_DIR" && \
    mkdir -p "$CRYPTREST_NGINX_OPT_DIR" && \
    chmod 700 "$CRYPTREST_NGINX_OPT_DIR"
}

nginx_define()
{
    cp "$CRYPTREST_MODULES_DIR/nginx/etc/"*conf.template "$CRYPTREST_NGINX_ETC_DIR/" && \
    chmod 400 "$CRYPTREST_NGINX_ETC_DIR/"* && \
    cp "$CRYPTREST_MODULES_DIR/nginx/opt/"*.sh "$CRYPTREST_NGINX_OPT_DIR/" && \
    chmod 400 "$CRYPTREST_NGINX_OPT_DIR/"*.sh && \
    ln -s "$CRYPTREST_NGINX_OPT_DIR/letsencrypt-init.sh" "$CRYPTREST_NGINX_BIN_LETSENCRYPT_INIT_FILE" && \
    ln -s "$CRYPTREST_NGINX_OPT_DIR/openssl-init.sh" "$CRYPTREST_NGINX_BIN_OPENSSL_INIT_FILE" && \
    ln -s "$CRYPTREST_NGINX_OPT_DIR/init.sh" "$CRYPTREST_NGINX_BIN_INIT_FILE" && \
    chmod 500 "$CRYPTREST_NGINX_OPT_DIR/"*init.sh && \

    echo "# $CRYPTREST_NGINX_TITLE" >> "$CRYPTREST_ENV_FILE"
    echo "CRYPTREST_NGINX_CMD_START=\"$CRYPTREST_NGINX_CMD_START\"" >> "$CRYPTREST_ENV_FILE"
    echo "CRYPTREST_NGINX_CMD_STOP=\"$CRYPTREST_NGINX_CMD_STOP\"" >> "$CRYPTREST_ENV_FILE"
    echo "CRYPTREST_NGINX_ARCH=\"$CRYPTREST_NGINX_ARCH\"" >> "$CRYPTREST_ENV_FILE"
    echo "CRYPTREST_NGINX_OS=\"$CRYPTREST_NGINX_OS\"" >> "$CRYPTREST_ENV_FILE"
    echo '' >> "$CRYPTREST_ENV_FILE"
    echo '' >> "$CRYPTREST_ENV_FILE"

    echo "CRYPTREST_NGINX_* variables added in '$CRYPTREST_ENV_FILE'"
    echo ''
}


echo ''
echo "$CRYPTREST_NGINX_TITLE: init"
echo ''

nginx_prepare && \
nginx_install && \
nginx_define
