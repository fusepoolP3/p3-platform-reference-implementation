#!/bin/bash
# All ports based on https://github.com/fusepoolP3/overall-architecture/blob/master/default-ports.md

# Webserver for GUIs
# not sure why this is needed when mounting /var/log from data-container
mkdir /var/log/lighttpd
chown www-data:www-data  /var/log/lighttpd
/etc/init.d/lighttpd start
/usr/local/bin/wrapdocker

# start log service and start httpry to log requests on all the port we use
/etc/init.d/rsyslog start
httpry -f source-ip,request-uri -d -i eth0 'tcp port 8080 or 8181 or 8151 or 8200 or 8201 or 8202 or 8203 or 8204 or 8205 or 8300 or 8301 or 8302 or 8303 or 8304 or 8305 or 8306 or 8307 or 8308 or 8386' -o /var/log/httpry.log 


#iptables -A INPUT  -j LOG  --log-level debug --log-prefix '[p3-platform] '

# LDP
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-ldp-marmotta.jar &                             # Port 8080
if [ -z "$LDPURI" ]; then
    echo ldp uri is set
    export LDPURI=http://localhost:8080/
fi

echo LDPURI: $LDPURI

su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-proxy.jar -T $LDPURI &                                    # Port 8181
# Others
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-transformer-web-client.jar &                   # Port 8151

# GUIs
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-dashboard.jar &                                # Port 8200
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-pipeline-gui.jar &                             # Port 8201
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-dictionary-matcher-factory-gui.jar &           # Port 8202
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-batchrefine-factory-gui.jar -P 8203 &
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-xslt-factory-gui.jar &                         # Port 8204
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-resource-gui.jar &                             # Port 8205

# Transformers
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-pipeline-transformer.jar -C &                  # Port 8300
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-dictionary-matcher-transformer.jar &           # Port 8301
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-geo-enriching-transformer.jar -P 8302 &
su p3 -s /usr/bin/java -- -Xmx1g -jar /usr/local/lib/p3-any23-transformer.jar &                 # Port 8303
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-stanbol-launcher.jar -p 8304 &                 # Port 8304
su p3 -s /usr/bin/java -- -Xmx2g -jar /usr/local/lib/p3-literal-extraction-transformer.jar &    # Port 8305
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-silkdedup.jar &                                # Port 8306
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-xslt-transformer.jar &                         # port 8307
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-geocoordinates-transformer.jar -P 8308 &
# TODO: p3-osm-transformer, p3-bing-translate-transformer 

# starts up Elasticsearch - Logstash - Kibana
#cd /opt/ELK
#docker-compose up -d
#cd -

# start logstash forwarder to send httpry logs to the ELK stack just started
/etc/init.d/logstash-forwarder start

# start log.io server and forwarder
(log.io-server &) && (log.io-harvester 2> /dev/null &)

echo "PRESS CTRL-C to teminate"
sleep infinity
# docker run -p 8386:80 -e IR_URL=`/sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'` danilogiacomi/pundit







