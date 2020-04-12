#!/bin/bash

TAG_PREFIX=$1
if [ -z "$TAG_PREFIX" ]; then
    echo "Usage: $0 <tag_prefix>"
    exit 1
fi

docker build --build-arg TARGET_ARCH=amd64 -t $TAG_PREFIX/certbot:amd64-latest . --push
docker build --build-arg TARGET_ARCH=arm64v8 -t $TAG_PREFIX/certbot:arm64-latest . --push

docker manifest create $TAG_PREFIX/certbot:latest $TAG_PREFIX/certbot:amd64-latest $TAG_PREFIX/certbot:arm64-latest
docker manifest annotate --arch amd64 $TAG_PREFIX/certbot:latest $TAG_PREFIX/certbot:amd64-latest
docker manifest annotate --arch arm64 $TAG_PREFIX/certbot:latest $TAG_PREFIX/certbot:arm64-latest

docker manifest push -p $TAG_PREFIX/certbot:latest