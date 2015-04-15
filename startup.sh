#!/bin/bash
# All ports based on https://github.com/fusepoolP3/overall-architecture/blob/master/default-ports.md

# Webserver for GUIs
/etc/init.d/lighttpd start

# LDP
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-ldp-marmotta.jar &     # Port 8080
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-proxy.jar &     # Port 8181

# Others
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-transformer-web-client.jar -P 8151 &

# Transformers
# TODO: stanbol, p3-osm-transformer, punditTransformer, p3-bing-translate-transformer, p3-template-transformer
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-pipeline-transformer.jar -P 8190 -C &
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-dictionary-matcher-transformer.jar -P 8192 &
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-geo-enriching-transformer.jar -P 8193 &
su p3 -s /usr/bin/java -- -Xmx1g -jar /usr/local/lib/p3-any23-transformer.jar -p 8194 &
su p3 -s /usr/bin/java -- -Xmx2g -jar /usr/local/lib/p3-literal-extraction-transformer.jar -p 8196 &
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-silkdedup.jar -P 8197 &
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-xslt-transformer.jar -P 8198 &
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-geocoordinates-transformer.jar -P 8199
