ARG BASEIMG=ghcr.io/crac/jdk

FROM $BASEIMG AS builder
RUN apt-get update && apt-get install -y git maven
RUN cd /tmp && git clone https://github.com/CRaC/example-jetty
RUN cd /tmp/example-jetty && mvn package

FROM $BASEIMG
RUN mkdir /opt/example-jetty/
COPY --from=builder /tmp/example-jetty/target/dependency /opt/example-jetty/dependency
COPY --from=builder /tmp/example-jetty/target/example-jetty*.jar /opt/example-jetty/example-jetty.jar
CMD [ "/usr/bin/java", "-XX:CRaCCheckpointTo=/cr", "-jar", "/opt/example-jetty/example-jetty.jar" ]

