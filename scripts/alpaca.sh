#!/bin/sh
# Alpaca
echo "Building Alpaca"

HOME_DIR=$1

if [ -f "$HOME_DIR/islandora/configs/variables" ]; then
  . "$HOME_DIR"/islandora/configs/variables
fi

cd "$HOME_DIR"
git clone https://github.com/Islandora-CLAW/Alpaca.git
cd Alpaca
chown -R ubuntu:ubuntu "$HOME_DIR/Alpaca"
chown -R ubuntu:ubuntu "$HOME_DIR/.m2"
sudo -u ubuntu ./gradlew clean build install

# Chown everything over to the ubuntu user just in case
chown -R ubuntu:ubuntu "$HOME_DIR/Alpaca"
