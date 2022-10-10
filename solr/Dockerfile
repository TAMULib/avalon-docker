FROM        solr:6.6.4-alpine
MAINTAINER  Michael B. Klein <michael.klein@northwestern.edu>

ARG         TAMU_AVALON_BRANCH=tamu_development
ARG         TAMU_AVALON_REPO_RAW=https://raw.githubusercontent.com/TAMULib/avalon/

ADD         --chown=solr:solr ${TAMU_AVALON_REPO_RAW}${TAMU_AVALON_BRANCH}/solr/config/schema.xml avalon_conf/
ADD         --chown=solr:solr ${TAMU_AVALON_REPO_RAW}${TAMU_AVALON_BRANCH}/solr/config/solrconfig.xml avalon_conf/
