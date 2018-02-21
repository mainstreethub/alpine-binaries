#!/bin/sh

docker build ./ -t dynamodb-local
docker run --entrypoint /bin/sh --rm -iv ${PWD}:/host-volume dynamodb-local -s <<EOF
chown $(id -u):$(id -g) /DynamoDBLocal_lib/libsqlite4java-linux-amd64.so
cp -a /DynamoDBLocal_lib/libsqlite4java-linux-amd64.so /host-volume
EOF