# Fusepool P3 Platform Reference Implementation Docker Image

## Building

    docker build -t fusepoolp3/platform-reference-implementation .

## Running

    docker run -d --name=p3-platform -p 8181:8181 -p 8151:8151 -p 8205:80 -p 8300:8300 -p 8301:8301 -p 8302:8302 -p 8303:8303 -p 8305:8305 -p 8306:8306 -p 8307:8307 -p 8308:8308 fusepoolp3/platform-reference-implementation

## Using

When the container has finished starting, the different components of Fusepool P3 
can be accessed over the ports exposed by the container. Curently, these are:

* 8181 - Fusepool's Marmotta LDP over [p3-proxy](https://github.com/fusepoolP3/p3-proxy)
* 8151 - [p3-transformer-web-client](https://github.com/fusepoolP3/p3-transformer-web-client)
* 8205 - [p3-resource-gui](https://github.com/fusepoolP3/p3-resource-gui)
* 8300 - [p3-pipeline-transformer](https://github.com/fusepoolP3/p3-pipeline-transformer)
* 8301 - [p3-dictionary-matcher-transformer](https://github.com/fusepoolP3/p3-dictionary-matcher-transformer)
* 8302 - [p3-geo-enriching-transformer](https://github.com/fusepoolP3/p3-geo-enriching-transformer)
* 8303 - [p3-any23-transformer](https://github.com/fusepoolP3/p3-any23-transformer)
* 8305 - [p3-literal-extraction-transformer](https://github.com/fusepoolP3/p3-literal-extraction-transformer)
* 8306 - [p3-silkdedup](https://github.com/fusepoolP3/p3-silkdedup)
* 8307 - [p3-xslt-transformer](https://github.com/fusepoolP3/p3-xslt-transformer)
* 8308 - [p3-geocoordinates-transformer](https://github.com/fusepoolP3/p3-geocoordinates-transformer)
