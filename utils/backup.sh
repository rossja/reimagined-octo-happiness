#!/bin/bash

# simple backup script
# copies the database from the container to the host filesystem
# and commits the running containers to a tagged image ID

# TODO figure out a way to dynamically set this
containerVersion="0.0.1"

pgContainerId=$(docker ps -f ancestor=rossja/hlitw-pg --format "{{.ID}}")
redisContainerId=$(docker ps -f ancestor=rossja/hlitw-redis --format "{{.ID}}")
appContainerId=$(docker ps -f ancestor=rossja/hlitw-app --format "{{.ID}}")
pgContainerDir=/var/lib/postgresql/data
localhostDir=./postgres
dbBackupDir=./backups
sqlFile=hlitw-latest.sql

echo -e "\nHLITW backup starting...\n\n"

# commit the images
echo -e "commiting docker containers to images"
docker commit ${appContainerId} rossja/hlitw-app:${containerVersion}
docker commit ${pgContainerId} rossja/hlitw-postgres:${containerVersion}
docker commit ${redisContainerId} rossja/hlitw-redis:${containerVersion}

# dump the hlitw database to a .sql file
echo -e "backing up hlitw database to localhost..."
docker exec ${pgContainerId} su postgres -c 'pg_dump hlitw_development' > ${dbBackupDir}/${sqlFile}
echo -e "pg_dump complete!"

# process optional args
if [ $# -ne 0 ] ; then
  case $1 in
    -d)
      # flag to backup the posgres data directory was passed
      # this is useful on a first-run, if the data directory
      # was not mounted initially when the container was run
      echo -e "backing up container directory to localhost..."
      docker cp ${pgContainerId}:${pgContainerDir} ${localhostDir}
    ;;

    *)
      echo -e "postgres data backup complete!"
    ;;
  esac
fi

echo -e "\nHLITW backup complete!\n\n"