FROM tomcat:9.0-jdk8-openjdk-slim

LABEL desc="Custom image built from a tomcat-debian base image"

ENV WAIT_FOR_DB_CONTAINER=""

ENV DHIS2_HOME=/DHIS2_home

RUN cp -avT $CATALINA_HOME/webapps.dist/manager $CATALINA_HOME/webapps/manager

RUN rm -rf /usr/local/tomcat/webapps/ROOT && \
     mkdir /usr/local/tomcat/webapps/ROOT && \
     mkdir $DHIS2_HOME && \
     adduser --system --disabled-password --group tomcat && \
     echo 'tomcat' >> /etc/cron.deny && \
     echo 'tomcat' >> /etc/at.deny

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        util-linux \
        bash \
        unzip \
        fontconfig

COPY ./shared/wait-for-it.sh /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +rx /usr/local/bin/docker-entrypoint.sh && \
    chmod +rx /usr/local/bin/wait-for-it.sh

COPY ./shared/server.xml /usr/local/tomcat/conf
COPY dhis.war /usr/local/tomcat/webapps/ROOT.war

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 5432

CMD ["catalina.sh", "run"]
