#!/bin/sh

install_command() {
  download_path=$1
  destination_path=$2
  cmd=""
  if [ "$(id -u)" != "0" ]; then
    echo "You will be prompted for your sudo password in order to install sidepro in /usr/local/bin."
    cmd+="sudo "
  fi
  cmd+="install -m 755 $download_path $destination_path"
  eval "$cmd"
}

if [[ ! "$PATH" == *":/usr/local/bin:"* ]]; then
  echo "Warning: Your path is missing /usr/local/bin, you need to add this to use sidepro."
fi

LATEST_VERSION=$(curl -s https://api.github.com/repos/vmfarms/sidepro/releases/latest 2>&1 | grep "tag_name" | sed -E 's/.*"([^"]+)".*/\1/')
if [ -z "$LATEST_VERSION" ]; then
  echo "Unable to determine the latest version."
  exit 1
fi
SIDEPRO_TMP="/tmp/sidepro-$(date +%s)"
curl -L "https://github.com/vmfarms/sidepro/releases/download/${LATEST_VERSION}/sidepro" -o "$SIDEPRO_TMP" > /dev/null 2>&1 

install_command "$SIDEPRO_TMP" "/usr/local/bin/sidepro"
