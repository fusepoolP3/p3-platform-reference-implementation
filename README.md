# Fusepool P3 Platform Reference Implementation Docker Image

## Building

    docker build -t fusepoolp3/platform-reference-implementation .

## Running

    docker run -p 8080:8181 -p 8081:80 -d fusepoolp3/platform-reference-implementation

## Using

Fusepool P3's [p3-proxy](https://github.com/fusepoolP3/p3-proxy) is accessible directly at <http://192.168.0.110:8080/>.
It can also be accessed using the [p3-resource-gui](https://github.com/fusepoolP3/p3-resource-gui) which can be found at <http://192.168.0.110:8081>.
