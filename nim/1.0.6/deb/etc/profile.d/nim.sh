# Khronos | nim.sh

OS="$(sw_vers -productVersion)"
OS="${OS%%.*}"

if [ "$OS" -ge 11 ]; then
  export NIMBLE_DIR="/usr/local/libexec/nim"
else
  export NIMBLE_DIR="$HOME/.nimble"
fi
export PATH="$NIMBLE_DIR/bin:$PATH"

unset OS
