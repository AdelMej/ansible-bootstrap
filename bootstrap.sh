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
LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/lib" && pwd)"

# flags
DEBUG=0
FORCE=0

# ------------------
# --- variables ----
# ------------------

USER="ansible"
KEY=""

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

while [ "$#" -gt 0 ]; do
	case "$1" in
	--user)
		USER="$2"
		shift 2
		;;
	--key)
		KEY="$2"
		shift 2
		;;
	--debug)
		DEBUG=1
		shift 1
		;;
	--force)
		FORCE=1
		shift 1
		;;
	*)
		log_failure "unknown argument: $1"
		exit 1
		;;
	esac
done

if [ -z "$KEY" ]; then
	log_failure "error: --key is required"
	exit 1
fi

printf "%s" "$KEY" | grep -q "^ssh-" || {
	log_failure "invalid ssh key format"
	exit 1
}

if ! command -v sudo >/dev/null 2>&1; then
	log_failure "sudo is not installed"
	exit 1
fi

if [ "$EUID" -ne 0 ]; then

	log_failure "must be run as root"
	exit 1

fi

if [ ! -d "$LIB_DIR" ]; then

	log_failure "lib directory not found"
	exit 1

fi

# normalization
KEY="$(echo "$KEY" | tr -d '\r')"
log_debug "ssh key got normalized"

log_success "running as root"

create_user "$USER" || fail "user creation failed"

setup_sudoer "$USER" || fail "sudo setup failed"

verify_sudoer "$USER" || fail "sudo verification failed"

setup_ssh "$USER" "$KEY" || fail "ssh setup failed"

verify_ssh "$USER" "$KEY" || fail "ssh verification failed"

if ! check_python; then

	install_python

fi

log_success "host is ready for ansible (ssh + sudo + python)"
