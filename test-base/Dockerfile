FROM ubuntu:latest AS builder
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates git libc6-dev gcc make
RUN cd /tmp && git clone https://github.com/fritzw/ld-preload-open && cd ld-preload-open && make all

FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends faketime libbsd0 libnftables1 software-properties-common && \
    add-apt-repository -y ppa:criu/ppa && \
    apt-get update && \
    apt-get install -y criu && \
    apt-get clean
# ubuntu:24.04 (latest as of writing this) has a buggy unshare:
# https://github.com/util-linux/util-linux/issues/2614
# Once ubuntu:latest uses utils-linux 2.40+ this can be removed.
COPY --from=ubuntu:22.04 /usr/bin/unshare /usr/bin/unshare
COPY --from=builder /tmp/ld-preload-open/path-mapping-quiet.so /opt/path-mapping-quiet.so
