pause() {
	local debug=$1

	if [ "$debug" -eq 1 ]; then

		read -rq "[?][continue] ..."

	else

		sleep 0.2

	fi
}
