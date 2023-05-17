ARG TAG=17-crac+5
ARG JDK=openjdk-${TAG}_linux-x64

FROM ubuntu:latest AS builder
# We are not using Docker ADD <remote src> command as this does not cache the file
RUN apt-get update && apt-get install -y wget
ARG TAG
ARG JDK
ARG CHECKSUM=bf4405578cd445e5c6501c76cf72aac555fc76dec35a41a5219e4511c099e1da
RUN cd /opt && wget -nv "https://github.com/CRaC/openjdk-builds/releases/download/$TAG/$JDK.tar.gz"
RUN echo "$CHECKSUM /opt/$JDK.tar.gz" > /opt/checksum
RUN sha256sum --check /opt/checksum
RUN cd /opt && tar xzf $JDK.tar.gz

FROM ubuntu:latest
ARG JDK
COPY --from=builder /opt/$JDK /opt/$JDK
# Symlink on well-known place is useful for exec form of CMD
RUN ln -s /opt/$JDK/bin/java /usr/bin/java
RUN mkdir /cr && chmod a+rwx /cr
ADD entrypoint.sh /opt/entrypoint.sh
ADD checkpoint.sh /opt/checkpoint.sh
ADD restore.sh /opt/restore.sh
ENTRYPOINT [ "/opt/entrypoint.sh" ]
CMD [ "bash" ]
# Unprivileged restore does not work ATM so we'll use root user
#RUN useradd -m -u 1000 user
#USER user
ENV JAVA_HOME /opt/$JDK
ENV PATH $JAVA_HOME/bin:/opt:$PATH

