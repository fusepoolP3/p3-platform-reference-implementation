#!/bin/bash

/etc/init.d/lighttpd start

su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-ldp-marmotta.jar &
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-proxy.jar &

su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-pipeline-transformer.jar -P 7100 -C &
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-transformer-web-client.jar -P 7101 &
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-silkdedup.jar -P 7102 &
su p3 -s /usr/bin/java -- -Xmx1g -jar /usr/local/lib/p3-any23-transformer.jar -p 7103 &
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-geo-enriching-transformer.jar -P 7104 &
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-xslt-transformer.jar -P 7105 &
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-dictionary-matcher-transformer.jar -P 7106 &
su p3 -s /usr/bin/java -- -Xmx2g -jar /usr/local/lib/p3-literal-extraction-transformer.jar -p 7107
