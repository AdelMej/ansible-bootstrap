# -----------------------------------
# --- function to rollback sudoer ---
# -----------------------------------
rollback_sudoer() {
	local user="$1"
	log_info "rolling back sudoer"

	if [ -f "/etc/sudoers.d/$user" ]; then

		rm -f "/etc/sudoers.d/$user"
		log_success "sudoer file removed"

	else

		log_warn "sudoer file not found"

	fi
}

# --------------------------------
# --- function to rollback ssh ---
# --------------------------------
rollback_ssh() {
	local user="$1"
	local key="$2"

	log_info "rolling back ssh config"

	local auth_keys="/home/$user/.ssh/authorized_keys"

	if [ -f "$auth_keys" ]; then

		grep -vxF "$key" "$auth_keys" >"$auth_keys.tmp"
		mv "$auth_keys.temp" "$auth_keys"
		log_success "ssh key removed"

	else

		log_warn "authorized_keys not found"

	fi
}

# ---------------------------------
# --- function to rollback user ---
# ---------------------------------
rollback_user() {
	local user="$1"

	log_info "rolling back user"

	if id "$user" >/dev/null 2>&1; then

		userdel -r "$user"
		log_success "user removed"

	else

		log_warn "user not found"

	fi
}

# ---------------------------------------
# --- function to rollback everything ---
# ---------------------------------------
rollback_all() {
	log_info "starting rollback"
	local user="$USER"
	local key="$KEY"

	log_debug "user is '$user'"
	log_debug "key length is '${#key}'"
	log_debug "SSH_CONFIGURED=$SSH_CONFIGURED"
	log_debug "SUDOER_CREATED=$SUDOER_CREATED"
	log_debug "USER_CREATED=$USER_CREATED"

	if [ "$SSH_CONFIGURED" -eq 1 ]; then

		rollback_ssh "$user" "$key"

	fi

	if [ "$SUDOER_CREATED" -eq 1 ]; then

		rollback_sudoer "$user"

	fi

	if [ "$USER_CREATED" -eq 1 ]; then

		rollback_user "$user"

	fi

	log_info "rollback complete"
}

# --------------------
# --- failure path ---
# --------------------
fail() {

	log_failure "$1"
	rollback_all
	exit 1

}
