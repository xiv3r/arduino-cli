# Requirements
- [Termux v0.118.3](https://github.com/termux/termux-app/releases/download/v0.118.3/termux-app_v0.118.3+github-debug_arm64-v8a.apk)
- Arm64

# Installation
```
apt update
pkg upgrade -y
pkg install proot proot-distro -y
proot-distro install debian
```
- Proot debian cli
```
apt update
apt upgrade -y
apt install wget -y

wget -O arduino-cli.deb https://github.com/arduino/arduino-cli/releases/download/v1.5.2-rc.1/arduino-cli_1.5.2-rc.1-1_arm64.deb
dpkg -i arduino-cli.deb
apt --fix-broken install -y
dpkg --configure -a
        
arduino-cli config init
arduino-cli config add board_manager.additional_urls https://espressif.github.io/arduino-esp32/package_esp32_index.json
arduino-cli core update-index
arduino-cli core install esp32:esp32
        
arduino-cli lib install "ArduinoJson"
arduino-cli lib install "PubSubClient"
git clone --depth 1 --branch 1.14.1 https://github.com/adafruit/RTClib.git ~/Arduino/libraries/RTClib

arduino-cli compile --fqbn esp32:esp32:esp32 --clean --output-dir firmware .
```
