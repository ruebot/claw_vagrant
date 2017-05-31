#!/bin/bash
echo "Installing Mirador"

#HOME_DIR=$1
#if [ -f "$HOME_DIR/islandora/configs/variables" ]; then
#  . "$HOME_DIR"/islandora/configs/variables
#fi
#cd "$HOME_DIR"

cd /tmp && { curl -LOk https://github.com/NVLI/mirador-js/archive/master.zip; curl -LOk https://ftp.drupal.org/files/projects/mirador-8.x-1.x-dev.zip ; cd -;}

cd /var/www/html/drupal/web/libraries && { unzip /tmp/master.zip -d . ;}

rm /tmp/master.zip

cd /var/www/html/drupal/web/modules/contrib/ && { unzip /tmp/mirador-8.x-1.x-dev.zip -d . ;} 

rm /tmp/mirador-8.x-1.x-dev.zip

echo 'for unknown reasons I cannot get permissions to allow this drush en to be scripted...'

echo 'you'll have to vagrant ssh, cd to /var/www/html/drupal, then execute the following drush (or I suppose you could gui enable):'

echo 'drush en mirador -y'

#"$DRUSH_CMD" en mirador -y

#drush pm-uninstall
