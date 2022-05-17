#!/bin/sh
## Source https://docs.docker.com/compose/startup-order/

set -e
  
until PGPASSWORD=postgres psql -h "localhost" -U "postgres" -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done
  
>&2 echo "Postgres is up - executing command"
