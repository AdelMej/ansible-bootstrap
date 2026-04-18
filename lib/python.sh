# ----------------------------------
# --- function to install python ---
# ----------------------------------
install_python() {

	log_info "installing python3"
	local pkg
	pkg="$(detect_pkg_manager)" || return 1

	case "$pkg" in
	apt)
		apt update
		apt install -y python3
		;;
	dnf)
		dnf install -y python3
		;;
	pacman)
		pacman -Sy --noconfirm python3
		;;
	zypper)
		zypper install -y python3
		;;
	*)
		log_failure "unknow package manager: $pkg"
		return 1
		;;
	esac

	log_success "python3 installed"
}
