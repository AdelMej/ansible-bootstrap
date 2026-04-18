#!/bin/bash
set -e

REPO_URL="https://github.com/AdelMej/ansible-bootstrap"
INSTALL_DIR="/tmp/bootstrap"

cleanup() {
	echo "[install] cleaning up..."
	rm -rf "$INSTALL_DIR"
}

trap cleanup EXIT

echo "[install] cloning repo..."
rm -rf "$INSTALL_DIR"
git clone "$REPO_URL" "$INSTALL_DIR"

cd "$INSTALL_DIR"

echo "[install] running bootstrap..."
./bootstrap.sh "$@"

echo "[install] done"
