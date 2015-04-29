#!/bin/bash
# All ports based on https://github.com/fusepoolP3/overall-architecture/blob/master/default-ports.md

# Webserver for GUIs
/etc/init.d/lighttpd start
/usr/local/bin/wrapdocker

# LDP
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-ldp-marmotta.jar &     # Port 8080
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-proxy.jar &     # Port 8181

# Others
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-transformer-web-client.jar -P 8151 &

# GUIs
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-dashboard.jar -P 8200 &
# TODO: su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-pipeline-gui.jar &     # Port 8201
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-dictionary-matcher-factory-gui.jar &       # Port 8202
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-batchrefine-factory-gui.jar -P 8203 &
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-xslt-factory-gui.jar &

# Transformers
# TODO: stanbol, p3-osm-transformer, punditTransformer, p3-bing-translate-transformer
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-pipeline-transformer.jar -P 8300 -C &
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-dictionary-matcher-transformer.jar -P 8301 &
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-geo-enriching-transformer.jar -P 8302 &
su p3 -s /usr/bin/java -- -Xmx1g -jar /usr/local/lib/p3-any23-transformer.jar &     # Port 8303
su p3 -s /usr/bin/java -- -Xmx2g -jar /usr/local/lib/p3-literal-extraction-transformer.jar -p 8305 &
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-silkdedup.jar -P 8306 &
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-xslt-transformer.jar -P 8307 &
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-geocoordinates-transformer.jar -P 8308 &
docker run -p 8310:7100 fusepool/p3-batchrefine
