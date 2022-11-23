#!/usr/bin/bash

set -e

if [ ${#} -eq 0 ]
then
    echo "No arguments supplied"
    exit 1
fi

/usr/bin/docker compose --file ${1}/docker-compose.yml pull
/usr/bin/docker compose --file ${1}/docker-compose.yml down

/usr/bin/tar --create --directory=${1} --file=${1}/data-site-a.tgz --gzip data-site-a
/usr/bin/tar --create --directory=${1} --file=${1}/data-site-b.tgz --gzip data-site-b
/usr/bin/tar --create --directory=${1} --file=${1}/data-db.tgz --gzip data-db

for executable in $(/usr/bin/find ${1}/update.d -executable -type f)
do
    ${executable}
done

/usr/bin/docker compose --file ${1}/docker-compose.yml up --detach
/usr/bin/docker image prune --all --force > $(/usr/bin/mktemp)
