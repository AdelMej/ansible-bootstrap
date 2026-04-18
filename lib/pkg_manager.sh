# --------------------
# --- dependencies ---
# --------------------
source "$(dirname "${BASH_SOURCE[0]}")/log.sh"

# ------------------------------------------------------
# --- function that return supported package manager ---
# ------------------------------------------------------
detect_pkg_manager() {
	if command -v apt >/dev/null 2>&1; then
		echo "apt"
		return 0
	fi

	if command -v dnf >/dev/null 2>&1; then
		echo "dnf"
		return 0
	fi

	if command -v pacman >/dev/null 2>&1; then
		echo "pacman"
		return 0
	fi

	if command -v zypper >/dev/null 2>&1; then
		echo "zypper"
		return 0
	fi

	log_failure "unsupported package manager"
	return 1
}
