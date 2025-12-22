#!/usr/bin/env bash
set -e

./scripts/requirements.sh

case "$(uname -s)" in
Darwin)
    ./scripts/macos.sh
    ;;
Linux)
    ./scripts/linux.sh
    ;;
*)
    echo "Unsupported OS: $(uname -s)"
    exit 1
    ;;
esac
