# Fusepool P3 Platform Reference Implementation Docker Core Image

This is the core image for running the [P3 Platform Reference Implementation](https://github.com/fusepoolP3/p3-platform-reference-implementation)
docker compose. It provides those services that are not (yet) available as
individual docker image.

## Getting

To get the latest version from dockerhub:

    docker pull fusepoolp3/platform-reference-implementat

## Building

If instead you want to build it yourself, clone the github repository and run:

    docker build -t fusepoolp3/platform-reference-implementat .

## Running

To access the Fusepool P3 entry page at the default port 80 start the docker like that

    docker run -d --name=p3-platform -p 80:80 -p 8181:8181 -p 8151:8151 -p 8200:8200 -p 8201:8201 -p 8202:8202 -p 8203:8203 -p 8204:8204 -p 8205:8205 -p 8300:8300 -p 8301:8301 -p 8302:8302 -p 8303:8303 -p 8304:8304 -p 8305:8305 -p 8306:8306 -p 8307:8307 -p 8308:8308 -p 8310:8310 -p 8386:8386 -p 8387:8387 -p 8388:8388 fusepoolp3/platform-reference-implementat

To stop the container:

    docker stop p3-platform

to restart the container:

    docker start p3-platform

Starting things can take quite a while, be patient. To see what's going on, use the following command:

    docker logs -f p3-platform
