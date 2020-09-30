FROM        postgres:9.4
MAINTAINER  Michael B. Klein <michael.klein@northwestern.edu>
ADD         init-db/* /docker-entrypoint-initdb.d/

RUN         apt-get update && apt-get install -y \
			dos2unix 
		
RUN 		dos2unix /docker-entrypoint-initdb.d/init-avalon-db.sh
RUN 		dos2unix /docker-entrypoint-initdb.d/init-fedora-db.sh