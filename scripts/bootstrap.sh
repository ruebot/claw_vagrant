#!/bin/bash

HOME_DIR=$1

if [ -f "$HOME_DIR/islandora/configs/variables" ]; then
  . "$HOME_DIR"/islandora/configs/variables
fi

if [ ! -d "$DOWNLOAD_DIR" ]; then
  mkdir -p "$DOWNLOAD_DIR"
fi

#######################################################################
# Work around for https://bugs.launchpad.net/cloud-images/+bug/1569237
echo "ubuntu:ubuntu" | chpasswd
#######################################################################

cd "$HOME_DIR"

# Set apt-get for non-interactive mode
export DEBIAN_FRONTEND=noninteractive

cp "$HOME_DIR"/islandora/configs/motd /etc/motd

# Update all the things.
apt-get -y -qq update && apt-get -y -qq upgrade

# SSH
apt-get -y -qq install openssh-server

# Build tools
apt-get -y -qq install build-essential

# Git vim
apt-get -y -qq install git vim

# Java
apt-get -y install openjdk-8-jdk openjdk-8-jdk-headless openjdk-8-jre
sed -i '$iJAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' /etc/environment
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Maven
apt-get -y -qq install maven

# Tomcat
apt-get -y -qq install tomcat8 tomcat8-admin
usermod -a -G tomcat8 ubuntu
sed -i '$i<user username="islandora" password="islandora" roles="manager-gui"/>' /etc/tomcat8/tomcat-users.xml
chown -R tomcat8:tomcat8 /var/lib/tomcat8
chown -R tomcat8:tomcat8 /var/log/tomcat8
chmod -R g+w /var/lib/tomcat8
chmod -R g+w /var/log/tomcat8
sed -i '$iJAVA_OPTS="${JAVA_OPTS} -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true"' /etc/defaults/tomcat8

# Wget and curl
apt-get -y -qq install wget curl

# Bug fix for Ubuntu 14.04 with zsh 5.0.2 -- https://bugs.launchpad.net/ubuntu/+source/zsh/+bug/1242108
export MAN_FILES
MAN_FILES=$(wget -qO- "http://sourceforge.net/projects/zsh/files/zsh/5.0.2/zsh-5.0.2.tar.gz/download" \
  | tar xz -C /usr/share/man/man1/ --wildcards "zsh-5.0.2/Doc/*.1" --strip-components=2)
for MAN_FILE in $MAN_FILES; do gzip /usr/share/man/man1/"${MAN_FILE##*/}"; done

# More helpful packages
apt-get -y -qq install htop tree zsh fish unzip

# Install imagemagick with jp2 support. 
# JP2 isn't included in Ubuntu imagemagick as per this launchpad ticket:
# https://bugs.launchpad.net/ubuntu/+source/openjpeg2/+bug/711061
# Looks like there is some effort to bring it in eventually.
apt-add-repository -yu ppa:lyrasis/imagemagick-jp2
apt-get -f install -y --allow-downgrades imagemagick=8:6.8.9.9-7ubuntu5.3ppa1 imagemagick-6.q16=8:6.8.9.9-7ubuntu5.3ppa1 imagemagick-common=8:6.8.9.9-7ubuntu5.3ppa1 libmagickcore-6.q16-2=8:6.8.9.9-7ubuntu5.3ppa1 libmagickcore-6.q16-2-extra=8:6.8.9.9-7ubuntu5.3ppa1 libmagickwand-6.q16-2=8:6.8.9.9-7ubuntu5.3ppa1
apt-mark hold imagemagick imagemagick-6.q16 imagemagick-common libmagickcore-6.q16-2 libmagickcore-6.q16-2-extra libmagickwand-6.q16-2 

# Set some params so it's non-interactive for the lamp-server install
debconf-set-selections <<< 'mysql-server mysql-server/root_password password islandora'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password islandora'
debconf-set-selections <<< "postfix postfix/mailname string islandora-fedora4.org"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"

# Set JAVA_HOME -- Java8 set-default does not seem to do this.
sed -i 's|#JAVA_HOME=/usr/lib/jvm/openjdk-6-jdk|JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64|g' /etc/default/tomcat8
