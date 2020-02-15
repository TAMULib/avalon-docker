FROM        solr:6.6.4-alpine
MAINTAINER  Michael B. Klein <michael.klein@northwestern.edu>
ARG         AVALON_BRANCH=develop
ARG         AVALON_REPO_RAW=https://raw.githubusercontent.com/avalonmediasystem/avalon/

ADD         --chown=solr:solr ${AVALON_REPO_RAW}${AVALON_BRANCH}/solr/config/schema.xml avalon_conf/
ADD         --chown=solr:solr ${AVALON_REPO_RAW}${AVALON_BRANCH}/solr/config/solrconfig.xml avalon_conf/