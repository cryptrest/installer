#!/bin/sh

CURRENT_DIR="${CURRENT_DIR:=$(cd $(dirname $0) && pwd -P)}"

. "$CURRENT_DIR/../.env"

"$CRYPTREST_DIR/env/letsencrypt/renew.sh"
