FROM ubuntu:trusty

RUN apt-get update && apt-get install -y wget openjdk-7-jre-headless && apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN adduser --disabled-password --gecos "P3 Platform" --uid 1000 p3

ADD startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

RUN cd /usr/local/lib/ && wget https://github.com/fusepoolP3/p3-ldp-marmotta/releases/download/v0.1.0-20141110/marmotta-v0.1.0-20141110.jar

ENV HOME /home/p3
WORKDIR /home/p3

CMD /usr/local/bin/startup.sh

