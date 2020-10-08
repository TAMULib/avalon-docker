#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
  CREATE ROLE $AVALON_DB_USER LOGIN PASSWORD '$AVALON_DB_PASSWORD';
  CREATE DATABASE avalon WITH ENCODING='UTF8';
  GRANT ALL PRIVILEGES ON DATABASE avalon TO $AVALON_DB_USER;
EOSQL

psql -v ON_ERROR_STOP=1 -d avalon --username "$POSTGRES_USER" <<-EOSQL
INSERT INTO role_maps(entry, parent_id) VALUES ('cn=douglas hahn,ou=applications,ou=digital initiatives,ou=user services,ou=useraccounts,dc=library,dc=tamu,dc=edu', 1);
INSERT INTO role_maps(entry, parent_id) VALUES ('cn=douglas hahn,ou=applications,ou=digital initiatives,ou=user services,ou=useraccounts,dc=library,dc=tamu,dc=edu', 3);
INSERT INTO role_maps(entry, parent_id) VALUES ('cn=douglas hahn,ou=applications,ou=digital initiatives,ou=user services,ou=useraccounts,dc=library,dc=tamu,dc=edu', 5);
EOSQL
