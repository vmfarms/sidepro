#!/bin/sh

install_command() {
  download_path=$1
  destination_path=$2
  cmd=""
  if [ "$(id -u)" != "0" ]; then
    echo "You will be prompted for your sudo password to install sidepro in /usr/local/bin."
    cmd+="sudo "
  fi
  
  # Create /usr/local/bin if it doesn't exist
  ${cmd}mkdir -p /usr/local/bin
  
  cmd+="install -m 755 $download_path $destination_path"
  eval "$cmd"
}

if ! command -v curl &> /dev/null; then
    echo "Error: curl is not installed. Please install curl and try again."
    exit 1
fi

if [[ ! "$PATH" == *":/usr/local/bin:"* ]]; then
  echo "Warning: Your path is missing /usr/local/bin, you need to add this to use sidepro."
fi

LATEST_VERSION=$(curl -s https://api.github.com/repos/vmfarms/sidepro/releases/latest 2>&1 | grep "tag_name" | sed -E 's/.*"([^"]+)".*/\1/')
if [ -z "$LATEST_VERSION" ]; then
    echo "Unable to determine the latest version. Please visit the following URL to download manually:"
    echo "https://github.com/vmfarms/sidepro/releases"
    echo "After downloading, you can install it using: sudo install -m 755 /path/to/downloaded/sidepro /usr/local/bin/sidepro"
    exit 1
fi
SIDEPRO_TMP="/tmp/sidepro-$(date +%s)"
curl -L "https://github.com/vmfarms/sidepro/releases/download/${LATEST_VERSION}/sidepro" -o "$SIDEPRO_TMP" > /dev/null 2>&1 
if [ $? -ne 0 ]; then
    echo "Failed to download sidepro. Please check your internet connection and try again."
    exit 1
fi

install_command "$SIDEPRO_TMP" "/usr/local/bin/sidepro"

# Clean up the temporary file
rm -f "$SIDEPRO_TMP"

echo "sidepro has been successfully installed to /usr/local/bin/sidepro"
