#!/bin/sh

CURRENT_DIR="${CURRENT_DIR:=$(cd "$(dirname "$0")" && pwd -P)}"

CRYPTREST_ENV_FILE="$CURRENT_DIR/../.env"
CRYPTREST_NGINX_ETC_ENV_FILE="$CURRENT_DIR/../etc/nginx/.env"

if [ ! -f "$CRYPTREST_ENV_FILE" ]; then
    CRYPTREST_ENV_FILE="$CURRENT_DIR/../../.env"
    if [ ! -f "$CRYPTREST_NGINX_ETC_ENV_FILE" ]; then
        CRYPTREST_NGINX_ETC_ENV_FILE="$CURRENT_DIR/../../etc/nginx/.env"
    fi
fi

. "$CRYPTREST_ENV_FILE"
. "$CRYPTREST_NGINX_ETC_ENV_FILE"


CRYPTREST_DIR="${CRYPTREST_DIR:=$(cd "$(dirname "$0")"/../ && pwd -P)}"


nginx_init()
{
    local modules='letsencrypt openssl'
    local m_file=''

    for m in $modules; do
        m_file="$CRYPTREST_DIR/bin/cryptrest-nginx-$m-init"

        if [ -f "$m_file" ]; then
            . "$m_file"
            break
        fi
    done
}


nginx_init
