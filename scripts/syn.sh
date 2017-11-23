#!/bin/sh
# Syn
echo "Building Syn"

HOME_DIR=$1

if [ -f "$HOME_DIR/islandora/configs/variables" ]; then
  . "$HOME_DIR"/islandora/configs/variables
fi

cd "$HOME_DIR"
git clone https://github.com/Islandora-CLAW/Syn.git
cd Syn
chown -R $CLAW_USER. "$HOME_DIR/Syn"
sudo -u $CLAW_USER ./gradlew build

cp build/libs/islandora-syn-*-all.jar /var/lib/tomcat8/lib/
sed -i 's|</Context>|    <Valve className="ca.islandora.syn.valve.SynValve"/>\n</Context>|g' /var/lib/tomcat8/conf/context.xml
cp "$HOME_DIR/islandora/configs/Syn/web.xml" /var/lib/tomcat8/webapps/fcrepo/WEB-INF/web.xml
cp "$HOME_DIR/islandora/configs/Syn/syn-settings.xml" /var/lib/tomcat8/conf/syn-settings.xml
sed -i "s|/home/ubuntu|$HOME_DIR|g" /var/lib/tomcat8/conf/syn-settings.xml

service tomcat8 restart
