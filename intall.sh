#!/bin/bash

THIS="$(basename $0)"
THISDIR="$(cd `dirname $0` && pwd)"

src_command="${THISDIR}/gerrit"
src_completion="${THISDIR}/gerrit-completion.bash"

dst_command='/usr/local/bin/'
dst_completion='/etc/bash_completion.d/'

do_install_completion='y'

completion_prefix=

install_command='ln -is'

die() {
  echo -e "${@}"
  exit
}

command_exists() {
  command -v "$1" &> /dev/null
}

os_is_mac() {
  [[ $(uname -s) == "Darwin" ]]
}

os_is_windows() {
  # MSYSGIT
  [[ $(uname -s) =~ MINGW* ]]
}

is_root() {
  [[ $(id -u) -eq 0 ]]
}

if ! is_root; then
  exec sudo -p "Install will need sudo permissions to continue. Password: " "$0" "${@}"
  exit $?
fi

while [[ $# -gt 0 ]]; do

  case $1 in
    --copy)
      install_command='cp -i'
      ;;

    --force-copy)
      install_command='cp -f'
      ;;
  esac

  shift

done

if os_is_mac; then

  if command_exists brew; then
    completion_prefix="$(brew --prefix)"
  elif command_exists port; then
    completion_prefix="${prefix}"
  else
    echo "Mac detected without Homebrew or MacPorts, bash completion for gerrit-sh will not be installed"
    do_install_completion='n'
  fi

elif os_is_windows; then

  die "Installation on Windows (MSYSGIT) not yet supported, but gerrit-sh will still work if you know how to manually install it..."

fi
 
if [[ -n $completion_prefix ]]; then
  dst_completion="${completion_prefix}${dst_completion}"
fi


if [[ ! -d $dst_command ]]; then
  mkdir -p "$dst_command"
fi

echo "Installing gerrit command to ${dst_command}"
sudo $install_command "$src_command" "$dst_command"

if [[ $do_install_completion == 'y' ]]; then

  if [[ ! -d $dst_completion ]]; then
    mkdir -p "$dst_completion"
  fi

  echo "Installing gerrit completion to ${dst_completion}"
  sudo $install_command "$src_completion" "$dst_completion"

fi
