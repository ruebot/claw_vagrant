#!/bin/bash
echo "Installing Islandora Karaf Components"

HOME_DIR=$1

if [ -f "$HOME_DIR/islandora/configs/variables" ]; then
  . "$HOME_DIR"/islandora/configs/variables
fi

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

echo "Installing Karaf Features"

cp $KARAF_CONFIGS/alpaca.script /tmp/alpaca.script
sed -i "s|/home/ubuntu|$HOME_DIR|g" /tmp/alpaca.script

$KARAF_CLIENT -f /tmp/alpaca.script
