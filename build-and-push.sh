#!/bin/sh

# This scripts builds the image and pushes it to its Docker Hub repository

REPO=smarthelios/ekstools
TAG=$1

docker build -t ${REPO}:${TAG} .

docker tag ${REPO}:${TAG}

docker push ${REPO}:${TAG}