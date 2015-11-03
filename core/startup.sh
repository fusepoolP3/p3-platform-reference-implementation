#!/bin/bash
# All ports based on https://github.com/fusepoolP3/overall-architecture/blob/master/default-ports.md

# Webserver for GUIs
# not sure why this is needed when mounting /var/log from data-container
mkdir /var/log/logstash-forwarder


# start log service and start httpry to log requests on all the port we use
/etc/init.d/rsyslog start
httpry -f source-ip,request-uri -d -i eth0 'tcp port 8080 or 8181 or 8151 or 8200 or 8201 or 8202 or 8203 or 8204 or 8205 or 8300 or 8301 or 8302 or 8303 or 8304 or 8305 or 8306 or 8307 or 8308 or 8386' -o /var/log/httpry.log 


#iptables -A INPUT  -j LOG  --log-level debug --log-prefix '[p3-platform] '

if [ -z "$LDPURI" ]; then
    echo ldp uri is set
    export LDPURI=http://localhost:8080/
fi

echo LDPURI: $LDPURI

su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-proxy.jar -T $LDPURI > /var/log/p3-proxy.log 2>&1 &    	    # Port 8181
# Others
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-transformer-web-client.jar > /var/log/web-client.log 2>&1 &    # Port 8151

# GUIs
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-dashboard.jar  &                               # Port 8200
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-pipeline-gui.jar &                             # Port 8201
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-dictionary-matcher-factory-gui.jar &           # Port 8202
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-batchrefine-factory-gui.jar -P 8203 &
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-xslt-factory-gui.jar &                         # Port 8204
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-resource-gui.jar &                             # Port 8205

# Transformers
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-pipeline-transformer.jar -C > /var/log/pipeline-transformer.log 2>&1 &              # Port 8300
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-dictionary-matcher-transformer.jar > /var/log/dictionary-matcher.log 2>&1 &         # Port 8301
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-geo-enriching-transformer.jar -P 8302  > /var/log/geo-enriching.log 2>&1  & 
su p3 -s /usr/bin/java -- -Xmx1g -jar /usr/local/lib/p3-any23-transformer.jar > /var/log/any23-transformer.log 2>&1 &                # Port 8303
su p3 -s /usr/bin/java -- -Xmx2g -jar /usr/local/lib/p3-literal-extraction-transformer.jar > /var/log/literal-extraction.log 2>&1 &  # Port 8305
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-silkdedup.jar > /var/log/silkdedup.log 2>&1 &                                       # Port 8306
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-xslt-transformer.jar > /var/log/xslt-transformer.log 2>&1 &                         # port 8307
su p3 -s /usr/bin/java -- -jar /usr/local/lib/p3-geocoordinates-transformer.jar -P 8308 > /var/log/geocoordinates-transformer.log 2>&1 &
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