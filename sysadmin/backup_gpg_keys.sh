#!/usr/bin/env bash

##
#+ Back up Gnupg keys in files.
#+
#+ References:
#+ * https://meng6.net/pages/computing/installing_and_configuring/installing_and_configuring_gpg/
##

## If gpg is not installed, exit.
type gpg >/dev/null 2>&1 || { echo >&2 "gpg is probably not installed. Aborting."; exit 1; }

if [[ ! $# -eq 2 ]]; then
	echo "Usage: $0 MY_GPG_KEY save_path"
fi

MY_GPG_KEY="$1"

( gpg --list-keys ${MY_GPG_KEY} || gpg --keyserver pgp.mit.edu --recv-keys ${MY_GPG_KEY} ) || { echo >&2 "ERROR: ${MY_GPG_KEY} is not a valid GnuPG key"; exit 1; }


SAVE_PATH="$2"

if [[ ! -d ${SAVE_PATH} ]]; then
	echo >&2 "ERROR: ${SAVE_PATH} is not a file path"
	exit 1
fi

if [[ ! -d  "${SAVE_PATH%%/}/gnupg_key__${MY_GPG_KEY}" ]]; then
	mkdir -p "${SAVE_PATH%%/}/gnupg_key__${MY_GPG_KEY}"
fi

if [[ -d  "${SAVE_PATH%%/}/${MY_GPG_KEY}" ]]; then
    gpg --no-batch -a --export ${MY_GPG_KEY} > "${SAVE_PATH%%/}/gnupg_key__${MY_GPG_KEY}/${MY_GPG_KEY}_public.asc" 
    gpg --no-batch -a --export-secret-keys ${MY_GPG_KEY} > "${SAVE_PATH%%/}/gnupg_key__${MY_GPG_KEY}/${MY_GPG_KEY}_secret.asc"
    gpg --no-batch -a --gen-revoke ${MY_GPG_KEY} > "${SAVE_PATH%%/}/gnupg_key__${MY_GPG_KEY}/${MY_GPG_KEY}_revoke.asc"
	7z a -p "${SAVE_PATH%%/}/gnupg_key__${MY_GPG_KEY}.7z" "${SAVE_PATH%%/}/gnupg_key__${MY_GPG_KEY}"
	if [[ -d "${SAVE_PATH%%/}/gnupg_key__${MY_GPG_KEY}" ]]; then
		rmtrash "${SAVE_PATH%%/}/gnupg_key__${MY_GPG_KEY}"
	else
		echo >&2 "WARNING: cannot safely delete ${SAVE_PATH%%/}/gnupg_key__${MY_GPG_KEY} with rmtrash. Please manually delete it."
	fi
fi

exit 0

## END
