#!/bin/bash

docker run --rm -ti \
  --privileged \
  --publish 80:8000 \
  -v /dev:/dev \
  -v ${HOME}/watchdir:/watchdir \
  -v ${HOME}/.cncrc:/root/.cncrc \
  --name cncjs \
  sprack/docker-raspi-cncjs:1.9.20

