# Khronos | golang.sh

export GOPATH="$HOME/go"

OS="$(sw_vers -productVersion)"
OS="${OS%%.*}"

if [ "$OS" -ge 11 ]; then
  export GOTMPDIR="/usr/tmp"
  export GOBIN="/usr/local/libexec/go/bin"
  export PATH="$PATH:$GOBIN"
else
  export PATH="$PATH:$GOPATH/bin"
fi

unset OS
