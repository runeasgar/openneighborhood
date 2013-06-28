#!/bin/bash

#set -o errexit

echo -e "OpenNeighborhood Deployment Script"

echo "What tag would you like to deploy? (e.g., 2013-06-21) "
read tag

echo "What environment for Drupal operations? (e.g., dev.on, stage.on, prod.on) "
read env

echo "Pulling $tag.. "
git reset --hard HEAD
git checkout master
git pull
git fetch --tags
git checkout $tag
echo -e "complete."

echo "Updating Drupal database.. "
drush @$env updatedb -y
echo -e "complete."

echo "Reverting features.. "
drush @$env  en features
drush @$env  features-revert-all -y
echo -e "complete."

echo "Clearing caches.. "
drush @$env cc all
echo -e "complete."

echo -e "Don't forget to run on-sync and drupal-permissions if needed.."

if [ "$?" -ne 0 ]
then
  echo "Deployment completed with errors.";
else
  echo "Deployment completed succesfully.";
fi
