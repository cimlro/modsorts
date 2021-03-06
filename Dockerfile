# Generated by IBM TransformationAdvisor
# Mon Jun 17 10:21:29 UTC 2019


#IMAGE: Get the base image for Liberty
FROM websphere-liberty:webProfile7

COPY --chown=1001:0 ./server.xml /config

# Optional functionality
ARG SSL=true

ARG MP_MONITORING=true
ARG HTTP_ENDPOINT=false

#BINARIES: Add in all necessary application binaries
COPY --chown=1001:0 Dockerfile ./binary/application/* /config/apps/


USER root
#FEATURES: Install any features that are required
RUN apt-get update && apt-get dist-upgrade -y \
&& rm -rf /var/lib/apt/lists/* 

USER 1001
RUN configure.sh

# Upgrade to production license if URL to JAR provided
ARG LICENSE_JAR_URL
RUN \
   if [ $LICENSE_JAR_URL ]; then \
     wget $LICENSE_JAR_URL -O /tmp/license.jar \
     && java -jar /tmp/license.jar -acceptLicense /opt/ibm \
     && rm /tmp/license.jar; \
   fi
