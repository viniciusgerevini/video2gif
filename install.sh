# THIS SCRIPT WAS CREATED USING NVM INSTALATION SCRIPT AS REFERENCE

{ # this ensures the entire script is downloaded #
v2g_latest_version() {
  echo '1.2.2'
}

v2g_script_url() {
  echo "https://raw.githubusercontent.com/viniciusgerevini/video2gif/$(v2g_latest_version)/video2gif"
}

v2g_has() {
  type "$1" > /dev/null 2>&1
}

v2g_try_profile() {
  if [ -z "${1-}" ] || [ ! -f "${1}" ]; then
    return 1
  fi
  echo "${1}"
}

v2g_detect_profile() {
  if [ "${PROFILE-}" = '/dev/null' ]; then
    # the user has specifically requested NOT to change their profile
    return
  fi

  if [ -n "${PROFILE}" ] && [ -f "${PROFILE}" ]; then
    echo "${PROFILE}"
    return
  fi

  local DETECTED_PROFILE=''

  if [ -n "${BASH_VERSION-}" ]; then
    if [ -f "$HOME/.bashrc" ]; then
      DETECTED_PROFILE="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
      DETECTED_PROFILE="$HOME/.bash_profile"
    fi
  elif [ -n "${ZSH_VERSION-}" ]; then
    DETECTED_PROFILE="$HOME/.zshrc"
  fi

  if [ -z "$DETECTED_PROFILE" ]; then
    for EACH_PROFILE in ".profile" ".bashrc" ".bash_profile" ".zshrc"
    do
      if DETECTED_PROFILE="$(v2g_try_profile "${HOME}/${EACH_PROFILE}")"; then
        break
      fi
    done
  fi

  if [ -n "$DETECTED_PROFILE" ]; then
    echo "$DETECTED_PROFILE"
  fi
}

v2g_get_installation_dir() {
  if [ -z "$V2G_HOME" ]; then
    echo "$HOME/.video2gif"
  else
    echo $V2G_HOME
  fi
}

v2g_download() {
  if v2g_has "curl"; then
    curl --compressed -q "$@"
  elif v2g_has "wget"; then
    # Emulate curl with wget
    ARGS=$(echo "$*" | command sed -e 's/--progress-bar /--progress=bar /' \
                            -e 's/-L //' \
                            -e 's/--compressed //' \
                            -e 's/-I /--server-response /' \
                            -e 's/-s /-q /' \
                            -e 's/-o /-O /' \
                            -e 's/-C - /-c /')
    eval wget $ARGS
  else
    echo >&2 'You need curl or wget to install video2gif'
  fi
}

v2g_install_script() {
  local installation_dir="$(v2g_get_installation_dir)"

  mkdir -p "$installation_dir"

  if [ -f "$installation_dir/video2gif" ]; then
    echo "=> video2gif is already installed in $installation_dir, trying to update the script"
  else
    echo "=> Downloading video2gif to '$installation_dir'"
  fi

  v2g_download -s "$(v2g_script_url)" -o "$installation_dir/video2gif" || {
    echo >&2 "Failed to download video2gif"
    return 1
  }
  
  chmod a+x "$installation_dir/video2gif" || {
    echo >&2 "Failed to mark '$installation_dir/video2gif' as executable"
    return 1
  }

  local profile="$(v2g_detect_profile)"
  local include_str="\\nalias video2gif=\"$installation_dir/video2gif\""

  if [ -z "${profile}" ]; then
    echo "=> Profile not found. Tried ~/.bashrc, ~/.bash_profile, ~/.zshrc, and ~/.profile."
    echo "=> Create one of them and run this script again"
    echo "   OR"
    echo "=> Append the following line to the correct file yourself:"
    command printf "${include_str}"
    echo
  else
    if ! command grep -qc '/video2gif' "$profile"; then
      echo "=> Appending video2gif alias to $profile"
      command printf "${include_str}" >> "$profile"
    else
      echo "=> video2gif alias already in $profile"
    fi
  fi

  echo "=> Close and reopen your terminal to start using video2gif or run the following to use it now:"
  command printf "${include_str}"
}

v2g_install_script

} # this ensures the entire script is downloaded #
