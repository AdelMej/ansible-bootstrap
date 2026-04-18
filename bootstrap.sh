#!/bin/bash

# -------------------
# --- shell setup ---
# -------------------

# exit on error
set -e
# disable history expension
set +H

# ---------------------------
# ---  constant variables ---
# ---------------------------

# variable for disabling banner
NO_BANNER=${NO_BANNER:-false}

# directory containing library scripts
LIB_DIR="$(dirname "$0")/lib"

# debug mode
DEBUG=0

# ------------------
# --- variables ----
# ------------------

USER="$1"
KEY="$2"

# ---------------------
# --- library files ---
# ---------------------

# shellcheck source=lib/log.sh
source "$LIB_DIR"/log.sh

# shellcheck source=lib/banner.sh
source "$LIB_DIR"/banner.sh

# shellcheck source=lib/create_user.sh
source "$LIB_DIR"/create_user.sh

# shellcheck source=lib/sudo.sh
source "$LIB_DIR"/sudo.sh

# shellcheck source=lib/ssh.sh
source "$LIB_DIR"/ssh.sh

# shellcheck source=lib/pause.sh
source "$LIB_DIR"/pause.sh

# shellcheck source=lib/checks.sh
source "$LIB_DIR"/checks.sh

# shellcheck source=lib/python.sh
source "$LIB_DIR"/python.sh

# -----------------
# --- bootstrap ---
# -----------------

if [ "$NO_BANNER" != "true" ]; then

	show_banner

fi

if ! command -v sudo >/dev/null 2>&1; then
	log_failure "sudo is not installed"
	exit 1
fi

if [ "$EUID" -ne 0 ]; then
	log_failure "must be run as root"
	exit 1
fi

# normalization
KEY="$(echo "$2" | tr -d '\r')"

log_success "running as root"
pause $DEBUG

create_user "$USER"
pause $DEBUG

setup_sudoer "$USER"
pause $DEBUG

verify_sudoer "$USER"
pause $DEBUG

setup_ssh "$USER" "$KEY"
pause $DEBUG

verify_ssh "$USER" "$KEY"
pause $DEBUG

if ! check_python; then

	install_python
	pause $DEBUG

fi

log_success "host is ready for ansible (ssh + sudo + python)"
