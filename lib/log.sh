# --------------------------
# --- constant viarables ---
# --------------------------

RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[38;5;214m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'
LOG_WIDTH=20

# ----------------
# --- info log ---
# ----------------

log_info() {
	local caller="${FUNCNAME[1]:-main}"
	printf "[%-*s] - [%bi%b] %s\n" \
		"$LOG_WIDTH" "$caller" "$BLUE" "$NC" "$1"
}

# -----------------------------
# ---  success log function ---
# -----------------------------

log_success() {
	local caller="${FUNCNAME[1]:-main}"
	printf "[%-*s] - %b[✔]%b %s\n" \
		"$LOG_WIDTH" "$caller" "$GREEN" "$NC" "$1"
}

# ----------------------------
# --- failure log function ---
# ----------------------------

log_failure() {
	local caller="${FUNCNAME[1]:-main}"
	printf "[%-*s] - %b[✖]%b %s\n" \
		"$LOG_WIDTH" "$caller" "$RED" "$NC" "$1" >&2
}

# -------------------
# --- warning log ---
# -------------------

log_warn() {
	local caller="${FUNCNAME[1]:-main}"
	printf "[%-*s] - %b[!]%b %s\n" \
		"$LOG_WIDTH" "$caller" "$ORANGE" "$NC" "$1"
}

# -----------------
# --- debug log ---
# -----------------

log_debug() {
	local caller="${FUNCNAME[1]:-main}"

	if [ "$DEBUG" -eq 1 ]; then
		printf "[%-*s] - %b[debug]%b %s\n" \
			"$LOG_WIDTH" "$caller" "$MAGENTA" "$NC" "$1"
	fi
}
