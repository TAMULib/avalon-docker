#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
  CREATE ROLE $AVALON_DB_USER LOGIN PASSWORD '$AVALON_DB_PASSWORD';
  CREATE DATABASE avalon WITH ENCODING='UTF8';
  GRANT ALL PRIVILEGES ON DATABASE avalon TO $AVALON_DB_USER;
EOSQL

