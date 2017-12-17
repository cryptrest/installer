#!/bin/sh

CRYPTREST_GO_VERSION="${CRYPTREST_GO_VERSION:=1.9.2}"
CRYPTREST_GO="go$CRYPTREST_GO_VERSION"
CRYPTREST_GO_DIR="$CRYPTREST_OPT_DIR/$CRYPTREST_GO"
CRYPTREST_GO_PATH="$CRYPTREST_SRC_DIR/go"
CRYPTREST_GO_TMP_DIR="$CRYPTREST_TMP_DIR/$CRYPTREST_GO"
CRYPTREST_GO_TITLE='Golang'

case "$(uname -m)" in
    x86_64 | amd64 )
        CRYPTREST_GO_ARCH='amd64'
    ;;
    x86 | i386 | i486 | i586 | i686 | i786 )
        CRYPTREST_GO_ARCH='386'
    ;;
    * )
        echo "ERROR: Current OS architecture has not been supported for $CRYPTREST_GO_TITLE"

        exit 1
    ;;
esac

case "$(uname -s)" in
    Linux )
        CRYPTREST_GO_OS='linux'
    ;;
    Darwin )
        CRYPTREST_GO_OS='darwin'
    ;;
    FreeBSD )
        CRYPTREST_GO_OS="freebsd"
    ;;
    * )
        echo "ERROR: Current OS does not supported for $CRYPTREST_GO_TITLE"

        exit 1
    ;;
esac

CRYPTREST_GO_URL_SRC="https://go.googlesource.com/go/+archive/$CRYPTREST_GO.tar.gz"
CRYPTREST_GO_URL="https://redirector.gvt1.com/edgedl/go/$CRYPTREST_GO.$CRYPTREST_GO_OS-$CRYPTREST_GO_ARCH.tar.gz"


go_src_download()
{
    mkdir -p "$CRYPTREST_GO_DIR" && \
    cd "$CRYPTREST_GO_DIR" && \
    curl -SL "$CRYPTREST_GO_URL_SRC" | tar -xz
    if [ $? -ne 0 ]; then
        echo "$CRYPTREST_GO_TITLE: Some error with download"
        rm -rf "$CRYPTREST_GO_DIR"

        exit 1
    fi
}

go_build()
{
    cd "$CRYPTREST_GO_DIR/src" && ./all.bash
}

go_prepare()
{
    rm -rf "$CRYPTREST_GO_TMP_DIR" && \
    rm -rf "$CRYPTREST_GO_DIR" && \
    [ -d "$CRYPTREST_BIN_DIR/" ] && \
    rm -f "$CRYPTREST_BIN_DIR/go"*
}

go_download()
{
    mkdir -p "$CRYPTREST_GO_TMP_DIR" && \
    cd "$CRYPTREST_GO_TMP_DIR" && \
    curl -SL "$CRYPTREST_GO_URL" | tar -xz
    if [ $? -ne 0 ]; then
        echo "$CRYPTREST_GO_TITLE: Some error with download"
        rm -rf "$CRYPTREST_GO_TMP_DIR"

        exit 1
    fi
}

go_install()
{
    mv "$CRYPTREST_GO_TMP_DIR/go" "$CRYPTREST_GO_DIR" && \
    rm -rf "$CRYPTREST_GO_TMP_DIR" && \
    chmod 700 "$CRYPTREST_GO_DIR" && \
    mkdir -p "$CRYPTREST_GO_PATH" && \
    chmod 700 "$CRYPTREST_GO_PATH" && \
    [ -d "$CRYPTREST_GO_DIR/bin/" ] && \
    for f in $(ls "$CRYPTREST_GO_DIR/bin/go"*); do
        ln -s "$f" "$CRYPTREST_BIN_DIR/$(basename $f)" && \
        chmod 500 "$f"
    done
}

go_define()
{
    echo "# $CRYPTREST_GO_TITLE" >> "$CRYPTREST_ENV_FILE"
    echo "export GOROOT=\"\$CRYPTREST_DIR/$(basename $CRYPTREST_OPT_DIR)/$CRYPTREST_GO\"" >> "$CRYPTREST_ENV_FILE"
    echo "export GOPATH=\"\$CRYPTREST_DIR/$(basename $CRYPTREST_SRC_DIR)/go\"" >> "$CRYPTREST_ENV_FILE"
    echo "export PATH=\"\$PATH:\$GOROOT/bin\"" >> "$CRYPTREST_ENV_FILE"
    echo "export GOARCH=\"$CRYPTREST_GO_ARCH\"" >> "$CRYPTREST_ENV_FILE"
    echo "export GOOS=\"$CRYPTREST_GO_OS\"" >> "$CRYPTREST_ENV_FILE"
    echo '' >> "$CRYPTREST_ENV_FILE"
    echo '' >> "$CRYPTREST_ENV_FILE"

    echo ''
    echo "GOPATH, GOROOT, GOOS, GOARCH and in PATH added in '$CRYPTREST_ENV_FILE'"
    echo ''
}


echo ''
echo "$CRYPTREST_GO_TITLE version: $CRYPTREST_GO_VERSION"
echo "$CRYPTREST_GO_TITLE source URL: $CRYPTREST_GO_URL"
echo "$CRYPTREST_GO_TITLE URL: $CRYPTREST_GO_URL"
echo ''

go_prepare && \
go_download && \
go_install && \
go_define
