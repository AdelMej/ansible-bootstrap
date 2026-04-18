# --------------------------------------------------
# --- script for setting up ansible sudoer files ---
# --------------------------------------------------

setup_sudoer() {
	local user="$1"

	log_debug "user is '$user'"

	if [ -z "$user" ]; then
		log_failure "user cannot be empty"
		return 1
	fi

	local file="/etc/sudoers.d/$user"

	if [ -f "$file" ]; then
		log_warn "sudoers file already exists: $file"

		if [ "$FORCE" -eq 0 ]; then
			read -rp "[?] overwrite? (y/n): " confirm
		else

			confirm="y"

		fi

		if [ "$confirm" != "y" ]; then
			log_info "skipping sudo setup"
			return 0
		fi
	fi

	log_info "creating sudoers file"

	echo "$user ALL=(ALL) NOPASSWD:ALL" >"$file" || {
		log_failure "failed to write sudoers file"
		return 1
	}

	SUDOER_CREATED=1

	log_info "setting permissions"

	chmod 440 "$file" || {
		log_failure "chmod failed"
		return 1
	}

	if ! visudo -c -f "$file" >/dev/null; then

		log_failure "invalid sudoers config" >&2
		rm -f "$file"
		return 1

	fi

	log_success "sudoers entry created for '$user'"
}

# -----------------------------------------
# --- function to verify if the sudoder ---
# -----------------------------------------

verify_sudoer() {
	local user="$1"
	local file="/etc/sudoers.d/$user"

	log_debug "user is '$user'"
	log_debug "file is '$file'"

	log_info "sudoers verification start"

	if [ -z "$user" ]; then
		log_failure "user cannot be empty"
		return 1
	fi

	check_file "$file" || return 1

	check_permission "$file" "440" || return 1

	if ! visudo -c -f "$file" >/dev/null 2>&1; then
		log_failure "sudoers file is invalid"
		return 1
	fi

	log_success "sudoers config valid"
}
