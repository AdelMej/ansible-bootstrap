# ----------------------------------------
# --- functions for checking ownership ---
# ----------------------------------------

check_owner() {
	local path="$1"
	local expected="$2"

	local actual

	log_debug "path is '$path'"
	log_debug "expected is '$expected'"

	actual="$(stat -c '%U:%G' "$path" 2>/dev/null)" || {

		log_failure "cannot stat $path"
		return 1

	}

	log_debug "actual is '$actual'"

	if [ "$actual" != "$expected" ]; then

		log_failure "$path owner is '$actual' (expected '$expected')"
		return 1

	fi

	log_success "$path owner ok"
}

# ----------------------------------------
# --- function for checking permission ---
# ----------------------------------------

check_permission() {
	local path="$1"
	local expected="$2"

	local actual

	log_debug "path is '$path'"
	log_debug "expected is '$expected'"

	actual="$(stat -c '%a' "$path" 2>/dev/null)" || {

		log_failure "cannot stat $path"
		return 1

	}

	log_debug "actual is '$actual'"

	if [ "$actual" != "$expected" ]; then

		log_failure "$path permission is '$actual' (expected '$expected')"
		return 1

	fi

	log_success "$path permission OK"
}

# -----------------------------------
# --- function for checking files ---
# -----------------------------------

check_file() {
	local path="$1"

	log_debug "path is '$path'"

	if [ ! -f "$path" ]; then

		log_failure "$path does not exist"
		return 1

	fi

	log_success "$path exists"
}

# -----------------------------------------
# --- function for checking directories ---
# -----------------------------------------

check_dir() {
	local path="$1"

	log_debug "path is '$path'"

	if [ ! -d "$path" ]; then

		log_failure "$path is not a directory"
		return 1

	fi

	log_success "$path is a directory"
}

# ------------------------------------------------
# --- function to check if python is installed ---
# ------------------------------------------------

check_python() {

	if command -v python3 >/dev/null 2>&1; then
		log_success "python3 is installed"
		return 0
	fi

	log_warn "python3 not found, installing"
	return 1
}
