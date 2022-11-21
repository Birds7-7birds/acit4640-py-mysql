#!/bin/sh

echo "[database]
MYSQL_HOST = $MYSQL_HOST
MYSQL_PORT = 3306
MYSQL_DB = $MYSQL_DATABASE
MYSQL_USER = $MYSQL_USER
MYSQL_PASSWORD = $MYSQL_PASSWORD" > ./backend.conf

# Abort on any error (including if wait-for-it fails).
set -m

# Wait for the backend to be up, if we know where it is.
if [ -n "$MYSQL_HOST" ]; then
  wait-for-it --timeout=30 "$MYSQL_HOST:${MYSQL_PORT:-6000}"
fi

gunicorn wsgi:app -b 0.0.0.0:8000 &

sleep 2

curl -X POST http://0.0.0.0:8000/add \
   -H 'Content-Type: application/json' \
   -d '{"name":"zavv","bcit_id":"a32334124"}'

fg %1
# Run the main container command.