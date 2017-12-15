#!/bin/sh

CRYPTREST_GO_VERSION="${CRYPTREST_GO_VERSION:=1.9.2}"
CRYPTREST_GO="go$CRYPTREST_GO_VERSION"
CRYPTREST_GO_DIR="$CRYPTREST_ENV_DIR/$CRYPTREST_GO"
CRYPTREST_GO_PATH="$CRYPTREST_SRC_DIR/go"
CRYPTREST_GO_TMP_DIR="$CRYPTREST_TMP_DIR/$CRYPTREST_GO"

#CRYPTREST_HOME_SHELL_PROFILE_FILES=".bash_profile .bashrc .mkshrc .profile .zlogin .zshrc"

case "$(uname -m)" in
    x86_64 | amd64 )
        CRYPTREST_GO_ARCH='amd64'
    ;;
    x86 | i386 | i486 | i586 | i686 | i786 )
        CRYPTREST_GO_ARCH='386'
    ;;
    * )
        echo "ERROR: Current OS architecture has not been supported for Golang"

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
        echo "ERROR: Current OS does not supported for Golang"

        exit 1
    ;;
esac

CRYPTREST_GO_URL_SRC="https://go.googlesource.com/go/+archive/$CRYPTREST_GO.tar.gz"
CRYPTREST_GO_URL="https://redirector.gvt1.com/edgedl/go/$CRYPTREST_GO.$CRYPTREST_GO_OS-$CRYPTREST_GO_ARCH.tar.gz"


golang_src_download()
{
    mkdir -p "$CRYPTREST_GO_DIR" && \
    cd "$CRYPTREST_GO_DIR" && \
    curl -SL "$CRYPTREST_GO_URL_SRC" | tar -xz
    if [ $? -ne 0 ]; then
        echo "Some error with download"
        rm -rf "$CRYPTREST_GO_DIR"

        exit 1
    fi
}

golang_build()
{
    cd "$CRYPTREST_GO_DIR/src" && ./all.bash
}

golang_prepare()
{
    rm -rf "$CRYPTREST_GO_TMP_DIR" && \
    rm -rf "$CRYPTREST_GO_DIR" && \
    [ -d "$CRYPTREST_BIN_DIR/" ] && \
    rm -f "$CRYPTREST_BIN_DIR/go"*
}

golang_download()
{
    mkdir -p "$CRYPTREST_GO_TMP_DIR" && \
    cd "$CRYPTREST_GO_TMP_DIR" && \
    curl -SL "$CRYPTREST_GO_URL" | tar -xz
    if [ $? -ne 0 ]; then
        echo "Some error with download"
        rm -rf "$CRYPTREST_GO_TMP_DIR"

        exit 1
    fi
}

golang_install()
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

golang_define()
{
    echo ''
    echo "GOPATH, GOROOT, GOOS, GOARCH and in PATH was added in '$CRYPTREST_ENV_FILE'"
    echo ''

    echo '# Golang' >> "$CRYPTREST_ENV_FILE"
    echo "export GOROOT=\"$CRYPTREST_GO_DIR\"" >> "$CRYPTREST_ENV_FILE"
    echo "export GOPATH=\"$CRYPTREST_GO_PATH\"" >> "$CRYPTREST_ENV_FILE"
    echo "export PATH=\"\$PATH:\$GOROOT/bin\"" >> "$CRYPTREST_ENV_FILE"
    echo "export GOARCH=\"$CRYPTREST_GO_ARCH\"" >> "$CRYPTREST_ENV_FILE"
    echo "export GOOS=\"$CRYPTREST_GO_OS\"" >> "$CRYPTREST_ENV_FILE"
    echo '' >> "$CRYPTREST_ENV_FILE"

#    for shell_profile_file in $CRYPTREST_HOME_SHELL_PROFILE_FILES; do
#        if [ -f "${HOME}/${shell_profile_file}" ]; then
#            echo "" >> "${HOME}/${shell_profile_file}"
#            echo "export GOROOT=\"\${HOME}/.${CRYPTREST_GO}\"  # Add GOROOT" >> "${HOME}/${shell_profile_file}"
#            echo "export GOPATH=\"\${HOME}/go\"  # Add GOPATH" >> "${HOME}/${shell_profile_file}"
#            echo "export PATH=\"\${PATH}:\${GOROOT}/bin\"  # Add Golang to PATH" >> "${HOME}/${shell_profile_file}"
#
#            . "${HOME}/${shell_profile_file}"
#
#            echo "    '${HOME}/${shell_profile_file}'"
#        fi
#    done
}


echo ''
echo "Golang version: $CRYPTREST_GO_VERSION"
echo "Golang source URL: $CRYPTREST_GO_URL"
echo "Golang URL: $CRYPTREST_GO_URL"
echo ''

golang_prepare && \
golang_download && \
golang_install && \
golang_define
