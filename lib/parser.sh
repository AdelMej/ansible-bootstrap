parse_arguments() {
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
}
