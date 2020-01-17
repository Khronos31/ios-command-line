# Khronos | golang.sh

export GOPATH="$HOME/go"

OS="$(sw_vers -productVersion)"
OS="${OS%%.*}"

if [ "$OS" -ge 11 ]; then
  export GOTMPDIR="/usr/tmp"
  export GOBIN="/usr/local/libexec/go/bin"
  export PATH="$GOBIN:$PATH"
else
  export PATH="$GOPATH/bin:$PATH"
fi

unset OS
