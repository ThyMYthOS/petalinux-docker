#! /bin/bash

#run-pynq-dev-container <image-id>
docker run -it -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev:/dev --privileged -v $PWD/opt/:/opt -v $PWD/workspace:/workspace  -v $PWD:/mnt $1 /bin/bash
