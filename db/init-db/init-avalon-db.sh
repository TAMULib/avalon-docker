#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
  CREATE ROLE $AVALON_DB_USER LOGIN PASSWORD '$AVALON_DB_PASSWORD';
  CREATE DATABASE avalon WITH ENCODING='UTF8';
  GRANT ALL PRIVILEGES ON DATABASE avalon TO $AVALON_DB_USER;
EOSQL

# Add dhahn@tamu.edu account since we are using SAML auth.  This will need to be a manual after spin up.
# psql -v ON_ERROR_STOP=1 -d avalon --username "$POSTGRES_USER" <<-EOSQL
# INSERT INTO role_maps(entry, parent_id) VALUES ('dhahn@tamu.edu', 1);
# INSERT INTO role_maps(entry, parent_id) VALUES ('dhahn@tamu.edu', 2);
# INSERT INTO role_maps(entry, parent_id) VALUES ('dhahn@tamu.edu', 3);
# EOSQL

# Add archivist1@example.com account since we are using SAML auth.  This will need to be a manual after spin up.
# After you add these make sure you restart Avalon
# psql -v ON_ERROR_STOP=1 -d avalon --username "$POSTGRES_USER" <<-EOSQL
# INSERT INTO role_maps(entry, parent_id) VALUES ('archivist1@example.com', 1);
# INSERT INTO role_maps(entry, parent_id) VALUES ('archivist1@example.com', 2);
# INSERT INTO role_maps(entry, parent_id) VALUES ('archivist1@example.com', 3);
# EOSQL
