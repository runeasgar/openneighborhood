#!/bin/bash

#set -o errexit

echo -e "OpenNeighborhood Deployment Script"

echo "What tag would you like to deploy? (e.g., 2013-06-21) "
read tag

echo "Pulling $tag.. "
git pull --tags
git checkout $tag
echo -e "complete."

echo "Updating Drupal database.. "
drush updatedb -y
echo -e "complete."

echo "Reverting features.. "
drush features-revert-all -y
echo -e "complete."

echo "Clearing caches.. "
drush cc all
echo -e "complete."

echo "Fixing permissions.. "
drupal-perms
echo -e "complete."

echo -e "Don't forget to run on_sync if you need to pull a database down."

if [ "$?" -ne 0 ]
then
  echo "Deployment completed with errors.";
else
  echo "Deployment completed succesfully.";
fi
