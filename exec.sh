#!/bin/sh

CURRENT_DIR="$(cd $(dirname $0) && pwd -P)"

CRYPTREST_DIR="$HOME/.cryptrest"
CRYPTREST_INSTALLER_DIR="$CRYPTREST_DIR/installer"
CRYPTREST_INSTALLER_PATH="$HOME/installer"
CRYPTREST_BRANCH='master'
CRYPTREST_GIT_URL="https://github.com/cryptrest/installer/archive/$CRYPTREST_BRANCH.tar.gz"
CRYPTREST_MODULES='go letsencrypt nginx'
CRYPTREST_IS_LOCAL=0


cryptrest_is_local()
{
    for i in $CRYPTREST_MODULES; do
        if [ ! -d "$CURRENT_DIR/$i" ]; then
            CRYPTREST_IS_LOCAL=1
            break
        fi
    done

    return $CRYPTREST_IS_LOCAL
}

cryptrest_local()
{
    for i in $CRYPTREST_MODULES; do
        "$CURRENT_DIR/$i/install.sh"
    done
}

cryptrest_download()
{
    mkdir -p "$CRYPTREST_DIR" && \
    cd "$CRYPTREST_DIR" && \
    curl -SL "$CRYPTREST_GIT_URL" | tar -xz
    if [ $? -ne 0 ]; then
        echo "Some error with download"
        rm -rf "$CRYPTREST_DIR"

        exit 1
    fi
}

cryptrest_network()
{
    cryptrest_download && \
    mv "$CRYPTREST_INSTALLER_DIR-$CRYPTREST_BRANCH" "$CRYPTREST_INSTALLER_DIR" && \
    chmod 700 "$CRYPTREST_DIR"
    if [ $? -eq 0 ]; then
        "$CRYPTREST_INSTALLER_DIR/exec.sh"
    fi
}

cryptrest_install()
{
    cryptrest_is_local
    if [ $? -eq 0 ]; then
        cryptrest_local && \
        mkdir -p "$CRYPTREST_INSTALLER_PATH" && \
        ln -s "$CURRENT_DIR/exec.sh" "$CRYPTREST_INSTALLER_PATH/index.html"
    else
        cryptrest_network && \
        mkdir -p "$CRYPTREST_INSTALLER_PATH" && \
        ln -s "$CRYPTREST_INSTALLER_DIR/exec.sh" "$CRYPTREST_INSTALLER_PATH/index.html"
    fi
}


cryptrest_install
