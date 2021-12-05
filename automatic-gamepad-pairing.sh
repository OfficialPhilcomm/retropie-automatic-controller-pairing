#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="automatic-gamepad-pairing"
rp_module_desc="RetroPie Automatic Gamepad Pairing"
rp_module_help="This script enables your RetroPie console to automatically find gamepads in pairing mode and connect to them."
rp_module_section="opt"
rp_module_flags="noinstclean nobin"
rp_module_repo="git https://github.com/OfficialPhilcomm/retropie-automatic-controller-pairing.git master"
rp_module_licence="MIT https://raw.githubusercontent.com/OfficialPhilcomm/retropie-automatic-controller-pairing/master/LICENSE.md"

function depends_automatic-gamepad-pairing() {
  getDepends ruby ruby-dev
}

function sources_automatic-gamepad-pairing() {
  gitPullOrClone "$md_inst"
}

function install_automatic-gamepad-pairing() {
  cd "$md_inst"
  chown -R $user:$user "$md_inst"

  sudo gem install bundler --conservative
  bundle install

  sudo cp retropie_automatic_gamepad_pairing.service /etc/systemd/system/retropie_automatic_gamepad_pairing.service

  sudo systemctl enable retropie_automatic_gamepad_pairing
  sudo systemctl start retropie_automatic_gamepad_pairing
}

function enable_automatic-gamepad-pairing() {
  sudo service enable retropie_automatic_gamepad_pairing
  printMsgs "dialog" "Automatic gamepad pairing enabled. It will start automatically on next boot"
}

function disable_automatic-gamepad-pairing() {
  sudo service disable retropie_automatic_gamepad_pairing
  printMsgs "dialog" "Automatic gamepad pairing disabled. It will no longer start automatically on boot"
}

function remove_automatic-gamepad-pairing() {
  cd "$md_inst"

  sudo systemctl stop retropie_automatic_gamepad_pairing
  sudo systemctl disable retropie_automatic_gamepad_pairing
  rm /etc/systemd/system/retropie_automatic_gamepad_pairing.service

  printMsgs "dialog" "Successfully uninstalled"
}

function gui_automatic-gamepad-pairing() {
  local cmd=()
  local options=(
    1 "Start automatic-gamepad-pairing now"
    2 "Stop automatic-gamepad-pairing now"
    3 "Enable automatic-gamepad-pairing on Boot"
    4 "Disable automatic-gamepad-pairing on Boot"
  )
  local choice
  local error_msg
  
  while true; do
    cmd=(dialog --backtitle "$__backtitle" --menu "What do you wanna do?" 22 86 16)
    choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    
    if [[ -n "$choice" ]]; then
      case "$choice" in
        1)
          sudo service retropie_automatic_gamepad_pairing start
          ;;

        2)
          sudo service retropie_automatic_gamepad_pairing stop
          ;;

        3)  
          enable_automatic-gamepad-pairing
          ;;

        4)
          disable_automatic-gamepad-pairing
          ;;
      esac
    else
      break
    fi
  done
}
