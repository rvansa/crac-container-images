FROM ubuntu:latest AS builder
RUN apt-get update && apt-get install -y curl git gcc make
RUN cd /tmp && git clone https://github.com/fritzw/ld-preload-open && cd ld-preload-open && make all

FROM ubuntu:latest
RUN apt-get update && apt-get install -y faketime libbsd0 libnftables1 && apt-get clean
COPY --from=builder /tmp/ld-preload-open/path-mapping-quiet.so /opt/path-mapping-quiet.so
