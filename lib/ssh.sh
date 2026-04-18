# ------------------------------------
# --- function to setup an ssh key ---
# ------------------------------------

setup_ssh() {
	local user="$1"
	local key="$2"

	local home="/home/$user"
	local ssh_dir="$home/.ssh"
	local auth_keys="$ssh_dir/authorized_keys"

	log_debug "user is '$user'"
	log_debug "key length is '${#key}'"

	log_debug "home is '$home'"
	log_debug "ssh directory is '$ssh_dir'"
	log_debug "authorized_keys directory is '$auth_keys'"

	if [ -z "$user" ] || [ -z "$key" ]; then

		log_failure "user and key cannot be empty"
		return 1

	fi

	if ! id "$user" >/dev/null 2>&1; then

		log_failure "user '$user' does not exist"
		return 1

	fi

	log_info "setting up ssh for '$user'"

	mkdir -p "$ssh_dir" || {

		log_failure "failed to create '$ssh_dir'"
		return 1

	}

	chown "$user:$user" "$ssh_dir"
	chmod 700 "$ssh_dir"

	if [ -f "$auth_keys" ] && grep -Fxq "$key" "$auth_keys"; then

		log_warn "key already exists"

	else

		echo "$key" >>"$auth_keys" || {
			log_failure "failed to write authorized_keys"
			return 1
		}

		SSH_CONFIGURE=1

	fi

	chown "$user:$user" "$auth_keys"
	chmod 600 "$auth_keys"

	log_success "ssh key configured for '$user'"
}

# ------------------------------------
# --- function to verify ssh setup ---
# ------------------------------------
verify_ssh() {

	local user="$1"

	local home="/home/$user"
	local ssh_dir="$home/.ssh"
	local auth_keys="$ssh_dir/authorized_keys"

	log_info "ssh verification start"

	check_dir "$ssh_dir" || return 1
	check_owner "$ssh_dir" "$user:$user" || return 1
	check_permission "$ssh_dir" "700" || return 1

	check_file "$auth_keys" || return 1
	check_owner "$auth_keys" "$user:$user" || return 1
	check_permission "$auth_keys" "600" || return 1

	log_success "ssh configuration valid"
}
