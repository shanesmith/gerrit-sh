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

opt_copy=
opt_force_copy=

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
  echo $(uname -s) | grep -q "MINGW*"
}

is_root() {
  [[ $(id -u) -eq 0 ]]
}


if ! is_root && ! os_is_windows; then
  exec sudo -p "Install will need sudo permissions to continue. Password: " "$0" "${@}"
  exit $?
fi

while [[ $# -gt 0 ]]; do

  case $1 in
    --copy)
      opt_copy='y'
      ;;

    --force-copy)
      opt_force_copy='y'
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

  # default install command for Windows is copy since linking isn't supported
  install_command="cp -i"
  do_install_completion='n'
  echo "NOTE: Installer for Windows will copy the gerrit tool to the installation directory, which means that you'll need to re-run this install each time you update this repository (ie: git pull)"

fi

if [[ $opt_force_copy ]]; then
  install_command='cp -f'
elif [[ $opt_copy ]]; then
  install_command='cp -i'
fi
 
if [[ -n $completion_prefix ]]; then
  dst_completion="${completion_prefix}${dst_completion}"
fi

if [[ ! -d $dst_command ]]; then
  mkdir -p "$dst_command"
fi

echo "Installing gerrit command to ${dst_command}"
$install_command "$src_command" "$dst_command"

if [[ $do_install_completion == 'y' ]]; then

  if [[ ! -d $dst_completion ]]; then
    mkdir -p "$dst_completion"
  fi

  echo "Installing gerrit completion to ${dst_completion}"
  $install_command "$src_completion" "$dst_completion"

fi
