# dhis-m1-docker

## Overview

This image has been tested on macOS Big Sur with M1 chip. The reason for developing this image is because the official DHIS2 images seemed to fail on Big Sur with the M1 chip.  The version of DHIS2 provided by this image is 	**2.37.3-SNAPSHOT**

## How to use this image

* Use the instructions available <a href="https://hub.docker.com/r/dhis2/core">here</a> on how to run DHIS2 images. 

docker run --rm -it -p 9090:8080 -v ./conf/dhis.conf:/DHIS2_home/dhis.conf mwebaze/dhis2-2.37.3-tomcat-9.0-jdk8-openjdk-slim

### Using docker-compose
```
version: '3'
services:
  database:
    container_name: dhis2-database
    #image: mwebaze/postgis-postgres-13:latest -- image with demo data
    image: postgres:13
    command: postgres -c max_locks_per_transaction=100
    volumes:
      - ./pgdata:/var/lib/postgresql/data
      #- ./conf/init.sql:/docker-entrypoint-initdb.d/init.sql
    environment:
      POSTGRES_USER: dhis
      POSTGRES_DB: dhis
      POSTGRES_PASSWORD: dhis
      #POSTGRES_DB_TARGET: dhis-target
      #PG_DATA: /var/lib/postgresql/data/pgdata:z
    ports:
     - "5432:5432"
  web:
    container_name: dhis2-web
    image: mwebaze/dhis2-2.37.3-tomcat-9.0-jdk8-openjdk-slim:latest
    volumes:
    - ./conf/dhis.conf:/DHIS2_home/dhis.conf
    - ./conf/hibernate.properties:/DHIS2_home/hibernate.properties
    environment:
      WAIT_FOR_DB_CONTAINER: "database:5432 -t 0"
      JAVA_OPTS: "-Xmx1024m -Xms512m"
      POSTGRES_DB: dhis
    ports:
    - "8085:8080"
    depends_on:
    - database
```
