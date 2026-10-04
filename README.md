# Requirements
- [Termux v0.118.3](https://github.com/termux/termux-app/releases/download/v0.118.3/termux-app_v0.118.3+github-debug_arm64-v8a.apk)
- Arm64

# Installation
```
apt update && pkg install wget -y && wget -qO- https://raw.githubusercontent.com/xiv3r/arduino-cli/refs/heads/main/install.sh | bash
```

# Install Libraries 
- examples
```
arduino-cli lib install "ArduinoJson"
arduino-cli lib install "PubSubClient"
git clone --depth 1 --branch 1.14.1 https://github.com/adafruit/RTClib.git ~/Arduino/libraries/RTClib
```

# Compile the sketch
- ESP32
```
arduino-cli compile --fqbn esp32:esp32:esp32 --clean --output-dir firmware .
```
- ESP8266
```
arduino-cli compile --fqbn esp8266:esp8266:nodemcuv2 --clean --output-dir firmware .
```
