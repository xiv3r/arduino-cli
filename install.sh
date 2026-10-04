#!/data/data/com.termux/files/usr/bin/bash
set -e

# ============================
# Termux setup
# ============================
echo ">>> Updating Termux packages..."
apt update
pkg upgrade -y -o Dpkg::Options::="--force-confnew"

echo ">>> Installing proot and proot-distro..."
pkg install proot proot-distro -y

echo ">>> Installing Debian via proot-distro..."
proot-distro install debian

# ============================
# Run Debian setup inside proot
# ============================
echo ">>> Entering Debian and running setup..."

proot-distro login debian -- bash -c '
set -e

echo ">>> [Debian] Updating packages..."
apt update
apt upgrade -y -o Dpkg::Options::="--force-confnew"
apt install wget git -y

echo ">>> [Debian] Downloading arduino-cli..."
wget -O arduino-cli.deb https://github.com/arduino/arduino-cli/releases/download/v1.5.2-rc.1/arduino-cli_1.5.2-rc.1-1_arm64.deb
dpkg -i arduino-cli.deb
apt --fix-broken install -y
dpkg --configure -a

echo ">>> [Debian] Configuring arduino-cli..."
arduino-cli config init
arduino-cli config add board_manager.additional_urls https://espressif.github.io/arduino-esp32/package_esp32_index.json
arduino-cli core update-index
arduino-cli core install esp32:esp32

echo ">>> [Debian] Installing libraries..."
arduino-cli lib install "ArduinoJson"
arduino-cli lib install "PubSubClient"
git clone --depth 1 --branch 1.14.1 https://github.com/adafruit/RTClib.git ~/Arduino/libraries/RTClib

echo ">>> [Debian] Compiling firmware..."
arduino-cli compile --fqbn esp32:esp32:esp32 --clean --output-dir firmware .

echo ">>> [Debian] Setup complete!"
'
