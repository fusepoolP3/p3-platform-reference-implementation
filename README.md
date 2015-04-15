# Fusepool P3 Platform Reference Implementation Docker Image

## Building

    docker build -t fusepoolp3/platform-reference-implementation .

## Running

    docker run -d --name=p3-platform -p 8181:8181 -p 8151:8151 -p 8190:8190 -p 8192:8192 -p 8193:8193 -p 8194:8194 -p 8196:8196 -p 8197:8197 -p 8198:8198 -p 8199:8199 -p 8205:80 fusepoolp3/platform-reference-implementation

## Using

When the container has finished starting, the different components of Fusepool P3 
can be accessed over the ports exposed by the container. Curently, these are:

* 8181 - Fusepool's Marmotta LDP over [p3-proxy](https://github.com/fusepoolP3/p3-proxy)
* 8151 - [p3-transformer-web-client](https://github.com/fusepoolP3/p3-transformer-web-client)
* 8190 - [p3-pipeline-transformer](https://github.com/fusepoolP3/p3-pipeline-transformer)
* 8192 - [p3-dictionary-matcher-transformer](https://github.com/fusepoolP3/p3-dictionary-matcher-transformer)
* 8193 - [p3-geo-enriching-transformer](https://github.com/fusepoolP3/p3-geo-enriching-transformer)
* 8194 - [p3-any23-transformer](https://github.com/fusepoolP3/p3-any23-transformer)
* 8196 - [p3-literal-extraction-transformer](https://github.com/fusepoolP3/p3-literal-extraction-transformer)
* 8197 - [p3-silkdedup](https://github.com/fusepoolP3/p3-silkdedup)
* 8198 - [p3-xslt-transformer](https://github.com/fusepoolP3/p3-xslt-transformer)
* 8199 - [p3-geocoordinates-transformer](https://github.com/fusepoolP3/p3-geocoordinates-transformer)
* 8205 - [p3-resource-gui](https://github.com/fusepoolP3/p3-resource-gui)
