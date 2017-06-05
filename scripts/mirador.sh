#!/bin/bash
echo "Installing Mirador"

HOME_DIR=$1

if [ -f "$HOME_DIR/islandora/configs/variables" ]; then
  . "$HOME_DIR"/islandora/configs/variables
fi

if [ ! -f "$DOWNLOAD_DIR/master.zip" ]; then
    echo "Downloading mirador-js dependencies"
    cd "$DOWNLOAD_DIR" && { curl -LOk https://github.com/NVLI/mirador-js/archive/master.zip; curl -LOk https://ftp.drupal.org/files/projects/mirador-8.x-1.x-dev.zip ; cd -;}
    cd "$DRUPAL_HOME"/web/libraries && { unzip "$DOWNLOAD_DIR"/master.zip -d . ;}
else echo "master.zip already exists"
fi


if  [ ! -f "$DOWNLOAD_DIR/mirador-8.x-1.x-dev.zip" ]; then
    echo "Downolading mirador drupal module"
    cd "$DRUPAL_HOME"/web/modules/contrib/ && { unzip "$DOWNLOAD_DIR"/mirador-8.x-1.x-dev.zip -d . ;}
    cd "$DRUPAL_ROOOT" && { $DRUSH_CMD en -y mirador ;}
else echo "module already exists"
fi
