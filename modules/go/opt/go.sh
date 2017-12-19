#!/bin/sh

CURRENT_DIR="${CURRENT_DIR:=$(cd $(dirname $0) && pwd -P)}"

. "$CURRENT_DIR/../.env"

CRYPTREST_DIR="${CRYPTREST_DIR:=$(cd $(dirname $0)/../ && pwd -P)}"


"$CRYPTREST_DIR/bin/go" $@
