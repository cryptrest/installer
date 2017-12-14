#!/bin/sh

CURRENT_DIR="$(cd $(dirname $0) && pwd -P)"


for i in go letsencrypt nginx; do
    "$CURRENT_DIR/$i/install.sh"
done
