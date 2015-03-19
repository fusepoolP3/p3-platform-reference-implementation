FROM ubuntu:trusty

RUN apt-get update && \
    apt-get install -y curl openjdk-7-jre-headless lighttpd git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN adduser --disabled-password --gecos "P3 Platform" --uid 3000 p3

ADD startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

RUN cd /usr/local/lib/ && \
    curl -Ls $(curl -s https://api.github.com/repos/fusepoolP3/p3-ldp-marmotta/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4) > marmotta.jar && \
    curl -Ls $(curl -s https://api.github.com/repos/fusepoolP3/p3-proxy/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4) > proxy.jar

RUN rm -r /var/www && \
    git clone https://github.com/fusepoolP3/p3-resource-gui.git /var/www && \
    rm -rf /var/www/.git

ENV HOME /home/p3
WORKDIR /home/p3

CMD /usr/local/bin/startup.sh

