FROM        postgres:9.6.24
MAINTAINER  Michael B. Klein <michael.klein@northwestern.edu>

ADD         init-db/* /docker-entrypoint-initdb.d/

# 11-11-2022 Repo not found..
# RUN         apt-get update
# RUN         apt-get install -y dos2unix
		
# RUN 		dos2unix /docker-entrypoint-initdb.d/init-avalon-db.sh
# RUN 		dos2unix /docker-entrypoint-initdb.d/init-fedora-db.sh
