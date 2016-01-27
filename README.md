# Fusepool P3 Platform Reference Implementation


## Prerequisites

this project requires `docker compose`. See the installation instructions here: https://docs.docker.com/compose/install/

## Running the docker compose

Change into the directory corresponsing to the backend you woul like to use, e.g:

    cd marmotta

From there run:

    docker-compose up

See the [Compose CLI reference](https://docs.docker.com/compose/reference/) for how to mange the containers started with docker-compose.

## Using

When the container has finished starting, you can access the Fusepool P3 
platform directly on the host running the container. With a web browser 
access http://\<yourhost>/. Important: The P3 Platform will autoconfigure itself 
with the hostname that it used to first access it, so if you intend the platform
to be accessible on http://example.com/ the first access must done using this URI
and *not* with http://localhost/, of course if you just want to try things out 
locally using /localhost/ is just fine.

The different components of Fusepool P3 
can be accessed over the ports exposed by the container. Curently, these are:

* 8181 - Fusepool's LDP over [p3-proxy](https://github.com/fusepoolP3/p3-proxy)
* 8151 - [p3-transformer-web-client](https://github.com/fusepoolP3/p3-transformer-web-client)
* 8200 - [p3-dashboard](https://github.com/fusepoolP3/p3-dashboard)
* 8201 - [p3-pipeline-gui-js](https://github.com/fusepoolP3/p3-pipeline-gui-js)
* 8202 - [p3-dictionary-matcher-factory-gui](https://github.com/fusepoolP3/p3-dictionary-matcher-factory-gui)
* 8203 - [p3-batchrefine-factory-gui](https://github.com/fusepoolP3/p3-batchrefine-factory-gui)
* 8204 - [p3-xslt-factory-gui](https://github.com/fusepoolP3/p3-xslt-factory-gui)
* 8205 - [p3-resource-gui](https://github.com/fusepoolP3/p3-resource-gui)
* 8300 - [p3-pipeline-transformer](https://github.com/fusepoolP3/p3-pipeline-transformer)
* 8301 - [p3-dictionary-matcher-transformer](https://github.com/fusepoolP3/p3-dictionary-matcher-transformer)
* 8302 - [p3-geo-enriching-transformer](https://github.com/fusepoolP3/p3-geo-enriching-transformer)
* 8303 - [p3-any23-transformer](https://github.com/fusepoolP3/p3-any23-transformer)
* 8305 - [p3-literal-extraction-transformer](https://github.com/fusepoolP3/p3-literal-extraction-transformer)
* 8306 - [p3-silkdedup](https://github.com/fusepoolP3/p3-silkdedup)
* 8307 - [p3-xslt-transformer](https://github.com/fusepoolP3/p3-xslt-transformer)
* 8308 - [p3-geocoordinates-transformer](https://github.com/fusepoolP3/p3-geocoordinates-transformer)
* 8310 - [p3-batchrefine](https://github.com/fusepoolP3/p3-batchrefine)
* 8386 - [p3-pundit-transformer](https://github.com/fusepoolP3/punditTransformer)
* 8387 - [Elasticsearch-Logstash-Kibana](https://www.elastic.co/products/logstash)
* 8388 - Real-time log monitoring with [Log.io](https://github.com/NarrativeScience/Log.io)

## Using Marmotta with PostgreSQL

By default Apache Marmotta is using an in-memory store. This is fine for testing but it should not be used in production. Instead it is recommended to use the [PostgreSQL backend](http://marmotta.apache.org/configuration.html) from Marmotta.

To enable PostgreSQL uncomment the according lines in `marmotta/docker-compose.yml` and run `docker-compose up`. Marmotta will now have access to a host called `postgres` and you can adjust the Marmotta configuration accordingly. For this go to `http://<yourhost>:8181/storage-kiwi/admin/database.html` and adjust the following parameters:

* Database: `postgres`
* Host: `jdbc:postgresql://postgres:5432/postgres?prepareThreshold=3`
* User: `postgres`
* Password: `yourPostgresPassword`

You can change the password by adjusting the environment variable `POSTGRES_PASSWORD` in `marmotta/docker-compose.yml`.

Once the connection is saved you can initialize the platform. Note that in case you want to use PostgreSQL you cannot do that before, it will not work! PostgreSQL is storing the data in the postgres docker container. Consult the [homepage](https://hub.docker.com/_/postgres/) to learn about how to customize this.

Note that the admin interface of Marmotta is public by default; you most probably want to lock that down in production.
