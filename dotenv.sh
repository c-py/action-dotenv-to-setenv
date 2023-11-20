#!/bin/sh
# Filename:      dotenv
# Purpose:       Export environment variables from .env file in GitHub Actions
# Authors:       Jason Leung (jason@madcoda.com)
#                Multiple Contributors (https://github.com/madcoda/dotenv-shell/graphs/contributors)
#                c-py (https://github.com/c-py)
# Bug-Reports:   see https://github.com/c-py/action-dotenv-to-setenv/issues
# License:       This file is licensed under the MIT License (MIT).
################################################################################


set -e

log_verbose() {
	if [ "$VERBOSE" = 1 ]; then
		echo "[dotenv.sh] $1" >&2
	fi
}

is_set() {
	eval val=\""\$$1"\"
	if [ -z "$(eval "echo \$$1")" ]; then
		return 1
	else
		return 0
	fi
}

is_comment() {
	case "$1" in
	\#*)
		log_verbose "Skip: $1"
		return 0
		;;
	esac
	return 1
}

is_blank() {
	case "$1" in
	'')
		log_verbose "Skip: $1"
		return 0
		;;
	esac
	return 1
}

is_node_options() {
   [[ "$1" == "NODE_OPTIONS" ]]
}

export_envs() {
	while IFS='=' read -r key temp || [ -n "$key" ]; do
		if is_comment "$key"; then
			continue
		fi

		if is_blank "$key"; then
			continue
		fi

		# check if $temp doesn't start with with ' or ", and quote it if so
		if [ "${temp%%[\"\']*}" = "${temp}" ]; then
			temp="\"${temp}\""
		fi

		# We have already quoted if necessary, so we can safely eval it
		# shellcheck disable=SC2086
		value=$(eval echo ${temp});

                # If this is node options output it to GITHUB_OUTPUT
                if is_node_options "$key"; then
                        echo "node_options=$value" >> $GITHUB_OUTPUT
                        continue
                fi

		eval export "$key='$value'";
		echo "$key=$value" >> $GITHUB_ENV;
	done < $1
}

# inject any defaults into the shell
if is_set "DOTENV_DEFAULT"; then
	log_verbose "Setting defaults via $DOTENV_DEFAULT"
	if [ -f "$DOTENV_DEFAULT" ]; then
		export_envs "$DOTENV_DEFAULT"
	else
		echo '$DOTENV_DEFAULT file not found' >&2
	fi
fi

if is_set "DOTENV_FILE"; then
	log_verbose "Reading from $DOTENV_FILE"
else
	DOTENV_FILE=".env"
fi

# inject .env configs into the shell
if [ -f "$DOTENV_FILE" ]; then
	export_envs "$DOTENV_FILE"
else
	echo "$DOTENV_FILE file not found" >&2
fi
