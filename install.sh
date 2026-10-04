#!/data/data/com.termux/files/usr/bin/bash
set -e

# ============================
# Termux setup
# ============================
echo -e "\033[32m>>> [Termux] Updating packages...\033[0m"
pkg upgrade -y -o Dpkg::Options::="--force-confnew"

echo -e "\033[32m>>> [Termux] Installing proot and proot-distro...\033[0m"
pkg install proot proot-distro -y

if [ -d "$PREFIX/var/lib/proot-distro/containers/debian" ]; then
    echo -e "\033[32m>>> [Termux] Debian already installed — skipping install.\033[0m"
else
    echo -e "\033[32m>>> [Termux] Installing Debian...\033[0m"
    proot-distro install debian
fi

# ============================
# Debian setup (inside proot)
# ============================
echo -e "\033[32m>>> Entering Debian and running setup...\033[0m"

proot-distro login debian -- bash -c '
set -e

echo -e "\033[32m>>> [Debian] Updating packages...\033[0m"
apt update
apt upgrade -y -o Dpkg::Options::="--force-confnew"
apt install wget -y

echo -e "\033[32m>>> [Debian] Installing arduino-cli...\033[0m"
wget -O arduino-cli.deb https://github.com/arduino/arduino-cli/releases/download/v1.5.2-rc.1/arduino-cli_1.5.2-rc.1-1_arm64.deb
dpkg -i arduino-cli.deb
apt --fix-broken install -y
dpkg --configure -a

echo -e "\033[32m>>> [Debian] Configuring arduino-cli board manager URLs...\033[0m"
arduino-cli config init
arduino-cli config add board_manager.additional_urls https://espressif.github.io/arduino-esp32/package_esp32_index.json
arduino-cli config add board_manager.additional_urls https://arduino.esp8266.com/stable/package_esp8266com_index.json
arduino-cli core update-index

echo -e "\033[32m>>> [Debian] Installing ESP32 core...\033[0m"
arduino-cli core install esp32:esp32

echo -e "\033[32m>>> [Debian] Installing ESP8266 core...\033[0m"
arduino-cli core install esp8266:esp8266

echo -e "\033[32m>>> [Debian] Verifying installed cores...\033[0m"
arduino-cli core list

echo -e "\033[32m>>> [Debian] ESP32 + ESP8266 setup complete!\033[0m"
'
