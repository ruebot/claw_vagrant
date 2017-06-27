#!/bin/bash
echo "Installing Mirador"

HOME_DIR=$1

if [ -f "$HOME_DIR/islandora/configs/variables" ]; then
  . "$HOME_DIR"/islandora/configs/variables
fi

if [ ! -f "$DOWNLOAD_DIR/master.zip" ]; then
    echo "Downloading mirador-js dependencies"
    cd "$DOWNLOAD_DIR" && { curl -LOk https://github.com/NVLI/mirador-js/archive/master.zip; cd -;}
   else echo "master.zip already exists"
fi

cd "$DRUPAL_HOME"/web/libraries && { unzip "$DOWNLOAD_DIR"/master.zip -d . ;}

if  [ ! -f "$DOWNLOAD_DIR/mirador-8.x-1.x-dev.zip" ]; then
    echo "Downloading mirador drupal module"
    cd "$DOWNLOAD_DIR" && { curl -LOk https://ftp.drupal.org/files/projects/mirador-8.x-1.x-dev.zip ;}
else echo "module already exists"
fi

cd "$DRUPAL_HOME"/web/modules/contrib/ && { unzip "$DOWNLOAD_DIR"/mirador-8.x-1.x-dev.zip -d . ;}
cd "$DRUPAL_ROOOT" && { $DRUSH_CMD en -y mirador ;}
