FROM groovy:jdk8-alpine AS build-env

USER root
RUN apk add --no-cache alpine-sdk subversion swig bash

# install gant
USER groovy
RUN mkdir .gradle && echo "gant_installPath = \${System.properties.'user.home'}/lib/gant" > .gradle/gradle.properties
RUN curl -sL https://github.com/Gant/Gant/archive/1.9.11.tar.gz | tar xz
RUN cd Gant-1.9.11; ./gradlew :gant:install

# build sqlite4java
RUN git clone -b linux-gccv4 https://bitbucket.org/almworks/sqlite4java.git
RUN sed -i.org -e '/^platforms=/s/linux-i386, //' sqlite4java/ant/linux.properties
RUN cd sqlite4java/ant; ~/lib/gant/bin/gant dist

FROM alpine:3.7 AS jar

ENV DDB_VERSION=2017-02-16

RUN apk add --no-cache curl

RUN curl -sL http://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_${DDB_VERSION}.tar.gz | tar xz


FROM openjdk:8-jre-alpine
MAINTAINER Minoru Nakata <minoru@sprocket.bz>

COPY --from=jar /DynamoDBLocal.jar /DynamoDBLocal.jar
COPY --from=jar /DynamoDBLocal_lib/ /DynamoDBLocal_lib/
COPY --from=build-env /home/groovy/sqlite4java/build/dist/libsqlite4java-linux-amd64.so /DynamoDBLocal_lib

ENTRYPOINT ["/usr/bin/java", "-Djava.library.path=./DynamoDBLocal_lib", "-jar", "DynamoDBLocal.jar"]

CMD ["-help"]