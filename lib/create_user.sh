# --------------------
# --- dependencies ---
# --------------------
#
source "$(dirname "${BASH_SOURCE[0]}")/log.sh"

# ---------------------------------
# --- function to create a user ---
# ---------------------------------

create_user() {
	local user="$1"

	if [ -z "$user" ]; then

		log_failure "user cannot be empty"
		return 1

	fi

	if id "$user" >/dev/null 2>&1; then

		log_success "user '$user' already exists"

	else

		useradd -m -s /bin/bash "$user"
		log_success "user '$user' created"

	fi
}
