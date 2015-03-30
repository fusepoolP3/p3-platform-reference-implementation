# Fusepool P3 Platform Reference Implementation Docker Image

## Building

    docker build -t fusepoolp3/platform-reference-implementation .

## Running

    docker run --name=p3-platform -p 8080:8181 -p 8081:80 -p 7100:7100 -p 7101:7101 -p 7102:7102 -p 7103:7103 -p 7104:7104 -p 7105:7105 -p 7106:7106 -p 7107:7107 -d fusepoolp3/platform-reference-implementation

## Using

Fusepool P3's [p3-proxy](https://github.com/fusepoolP3/p3-proxy) is accessible directly at <http://yourhost:8080/>.
It can also be accessed using the [p3-resource-gui](https://github.com/fusepoolP3/p3-resource-gui) which can be found at <http://yourhost:8081>.
