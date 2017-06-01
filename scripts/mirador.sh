#!/bin/bash
echo "Installing Mirador"

HOME_DIR=$1
if [ -f "$HOME_DIR/islandora/configs/variables" ]; then
  . "$HOME_DIR"/islandora/configs/variables
fi
cd "$HOME_DIR"

cd /tmp && { curl -LOk https://github.com/NVLI/mirador-js/archive/master.zip; curl -LOk https://ftp.drupal.org/files/projects/mirador-8.x-1.x-dev.zip ; cd -;}

cd "$DRUPAL_HOME"/web/libraries && { unzip /tmp/master.zip -d . ;}

rm /tmp/master.zip

cd "$DRUPAL_HOME"/web/modules/contrib/ && { unzip /tmp/mirador-8.x-1.x-dev.zip -d . ;} 

rm /tmp/mirador-8.x-1.x-dev.zip

#echo 'drush en mirador -y'

$DRUSH_CMD en -y mirador 
