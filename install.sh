#!/data/data/com.termux/files/usr/bin/bash
set -e

# ============================
# Termux setup
# ============================
echo ">>> [Termux] Updating packages..."
pkg upgrade -y -o Dpkg::Options::="--force-confnew"

echo ">>> [Termux] Installing proot and proot-distro..."
pkg install proot proot-distro -y

echo ">>> [Termux] Installing Debian..."
proot-distro install debian

# ============================
# Debian setup (inside proot)
# ============================
echo ">>> Entering Debian and running setup..."

proot-distro login debian -- bash -c '
set -e

echo ">>> [Debian] Updating packages..."
apt update
apt upgrade -y -o Dpkg::Options::="--force-confnew"
apt install wget -y

echo ">>> [Debian] Installing arduino-cli..."
wget -O arduino-cli.deb https://github.com/arduino/arduino-cli/releases/download/v1.5.2-rc.1/arduino-cli_1.5.2-rc.1-1_arm64.deb
dpkg -i arduino-cli.deb
apt --fix-broken install -y
dpkg --configure -a

echo ">>> [Debian] Configuring arduino-cli board manager URLs..."
arduino-cli config init
arduino-cli config add board_manager.additional_urls https://espressif.github.io/arduino-esp32/package_esp32_index.json
arduino-cli config add board_manager.additional_urls https://arduino.esp8266.com/stable/package_esp8266com_index.json
arduino-cli core update-index

echo ">>> [Debian] Installing ESP32 core..."
arduino-cli core install esp32:esp32

echo ">>> [Debian] Installing ESP8266 core..."
arduino-cli core install esp8266:esp8266

echo ">>> [Debian] Verifying installed cores..."
arduino-cli core list

echo ">>> [Debian] ESP32 + ESP8266 setup complete!"
'
