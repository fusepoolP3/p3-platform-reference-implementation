FROM java:8

EXPOSE 80 8181 8151 8200 8201 8202 8203 8204 8205 8300 8301 8302 8303 8304 8305 8306 8307 8308 8386 8387 8388

# Upgrade system and install required debs



RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl lxc lighttpd git  httpry && \
    echo 'deb http://packages.elasticsearch.org/logstashforwarder/debian stable main' > /etc/apt/sources.list.d/logstashforwarder.list && \
    curl http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add - && \
    apt-get update && \
    apt-get install -y logstash-forwarder nodejs-legacy npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

# Prepare docker-in-docker
#RUN curl -sSL https://get.docker.com/ubuntu/ | sh
#RUN curl https://raw.githubusercontent.com/jpetazzo/dind/master/wrapdocker -o /usr/local/bin/wrapdocker
#RUN chmod +x /usr/local/bin/wrapdocker
#VOLUME /var/lib/docker

# Fetch all self-containing P3-jars
RUN cd /usr/local/lib/ && \
    curl -Ls $(curl -s https://api.github.com/repos/fusepoolP3/p3-ldp-marmotta/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4) > p3-ldp-marmotta.jar && \
    curl -Ls $(curl -s https://api.github.com/repos/fusepoolP3/p3-proxy/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4) > p3-proxy.jar && \
    curl -Ls $(curl -s https://api.github.com/repos/fusepoolP3/p3-dictionary-matcher-factory-gui/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4) > p3-dictionary-matcher-factory-gui.jar && \
    curl -Ls $(curl -s https://api.github.com/repos/fusepoolP3/p3-batchrefine-factory-gui/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4) > p3-batchrefine-factory-gui.jar && \
    curl -Ls $(curl -s https://api.github.com/repos/fusepoolP3/p3-xslt-factory-gui/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4) > p3-xslt-factory-gui.jar && \
    curl -Ls $(curl -s https://api.github.com/repos/fusepoolP3/p3-pipeline-transformer/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4) > p3-pipeline-transformer.jar && \
    curl -Ls $(curl -s https://api.github.com/repos/fusepoolP3/p3-transformer-web-client/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4) > p3-transformer-web-client.jar && \
    curl -Ls $(curl -s https://api.github.com/repos/fusepoolP3/p3-silkdedup/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4) > p3-silkdedup.jar && \
    curl -Ls $(curl -s https://api.github.com/repos/fusepoolP3/p3-any23-transformer/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4) > p3-any23-transformer.jar && \
    curl -Ls $(curl -s https://api.github.com/repos/fusepoolP3/p3-geo-enriching-transformer/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4) > p3-geo-enriching-transformer.jar && \
    curl -Ls $(curl -s https://api.github.com/repos/fusepoolP3/p3-xslt-transformer/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4) > p3-xslt-transformer.jar && \
    curl -Ls $(curl -s https://api.github.com/repos/fusepoolP3/p3-dictionary-matcher-transformer/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4) > p3-dictionary-matcher-transformer.jar && \
    curl -Ls $(curl -s https://api.github.com/repos/fusepoolP3/p3-literal-extraction-transformer/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4) > p3-literal-extraction-transformer.jar && \
    curl -Ls $(curl -s https://api.github.com/repos/fusepoolP3/p3-geocoordinates-transformer/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4) > p3-geocoordinates-transformer.jar && \
    curl -Ls $(curl -s https://api.github.com/repos/fusepoolP3/p3-dashboard/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4) > p3-dashboard.jar && \
    curl -Ls $(curl -s https://api.github.com/repos/fusepoolP3/p3-pipeline-gui/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4) > p3-pipeline-gui.jar && \
    curl -Ls $(curl -s https://api.github.com/repos/fusepoolP3/p3-resource-gui/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4) > p3-resource-gui.jar && \
    curl -Ls $(curl -s https://api.github.com/repos/fusepoolP3/p3-stanbol-launcher/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4) > p3-stanbol-launcher.jar

# Setup webserver and add HTML-only GUIs
ADD index.html /var/www/html/index.html
RUN cd /var/www/html/ && \
    mkdir js && cd js && \
    git clone https://github.com/fusepoolP3/p3-autoconfiguration-tool.git autoconfig && \
    git clone https://github.com/rdf2h/rdf2h.git && \
    git clone https://github.com/rdf2h/ld2h.git && \
    rm -rf /var/www/html/*/.git && \
    chmod 644 /var/www/html/index.html

# Setup user & environment
RUN adduser --disabled-password --gecos "P3 Platform" --uid 3000 p3
ENV HOME /home/p3
WORKDIR /home/p3

#ADD ELK/logstash-forwarder.conf /etc/
#ADD ELK/docker-compose.yml /opt/ELK/
#ADD ELK/logstash-ssl/logstash-forwarder.crt /opt/ELK/logstash-ssl/logstash-forwarder.crt
#ADD ELK/logstash-ssl/logstash-forwarder.key /opt/ELK/logstash-ssl/logstash-forwarder.key
#ADD ELK/logstash-config/logstash.conf /opt/ELK/logstash-config/01_logstash.conf
#ADD ELK/logstash-config/patterns/httpry.pattern /opt/ELK/logstash-config/patterns/httpry.pattern



# RUN  wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add - \
    # echo 'deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main' | tee /etc/apt/sources.list.d/elasticsearch.list \
    # apt-get update \
    # apt-get -y install elasticsearch=1.4.4 \
    # service elasticsearch restart \
    # update-rc.d elasticsearch defaults 95 10 \
    # cd ~; wget https://download.elasticsearch.org/kibana/kibana/kibana-4.0.1-linux-x64.tar.gz \
    # tar xvf kibana-*.tar.gz \
    # mkdir -p /opt/kibana \
    # cp -R ~/kibana-4*/* /opt/kibana/ \
    # cd /etc/init.d && sudo wget https://gist.githubusercontent.com/thisismitch/8b15ac909aed214ad04a/raw/bce61d85643c2dcdfbc2728c55a41dab444dca20/kibana4 \
    # chmod +x /etc/init.d/kibana4 \
    # update-rc.d kibana4 defaults 96 9 \
    # service kibana4 start \
    

#RUN curl -L https://github.com/docker/compose/releases/download/1.2.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose ;\
#    chmod +x /usr/local/bin/docker-compose


ADD rsyslog.conf /etc/rsyslog.d/50-default.conf

# Install and configure logio
RUN npm install -g log.io --user "p3"
RUN echo "exports.config = {host:'0.0.0.0',port:8388}" > .log.io/web_server.conf
ADD harvester.conf /home/p3/.log.io/harvester.conf

# Setup & run startup-script
ADD startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh
CMD /usr/local/bin/startup.sh
