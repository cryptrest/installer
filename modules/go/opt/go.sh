#!/bin/sh

CURRENT_DIR="${CURRENT_DIR:=$(cd "$(dirname "$0")" && pwd -P)}"

CRYPTREST_ENV_FILE="$CURRENT_DIR/../.env"
CRYPTREST_GO_ETC_ENV_FILE="$CURRENT_DIR/../etc/go/.env"

if [ ! -f "$CRYPTREST_ENV_FILE" ]; then
    CRYPTREST_ENV_FILE="$CURRENT_DIR/../../.env"
    if [ ! -f "$CRYPTREST_GO_ETC_ENV_FILE" ]; then
        CRYPTREST_GO_ETC_ENV_FILE="$CURRENT_DIR/../../etc/go/.env"
    fi
fi

. "$CRYPTREST_GO_ETC_ENV_FILE"

CRYPTREST_DIR="${CRYPTREST_DIR:=$(cd $(dirname $0)/../ && pwd -P)}"


"$CRYPTREST_DIR/bin/go" $@
