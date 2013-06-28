#!/bin/bash

set -o errexit

echo -e "OpenNeighborhood Database Sync"

echo "Source environment (dev.on, stage.on, on): "
read srcenv

echo "Destination environment (dev.on, stage.on, on): "
read destenv

echo "Beginning drush sql-sync.. "
drush sql-sync @$srcenv @$destenv -y

drush @$destenv vset site_name "OpenNeighborhood $destenv Environment"
drush @$destenv vset syslog_identity "$destenv"
drush @$destenv vset file_private_path "/var/www/private/$destenv.joshuataylor.co"

if [ "$?" -ne 0 ]
then
  echo "Database sync completed with errors.";
else
  echo "Database sync completed succesfully.";
fi
