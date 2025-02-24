FROM alpine:latest AS builder
RUN apk add build-base curl git musl-fts-dev
RUN cd /tmp && git clone https://github.com/fritzw/ld-preload-open
RUN cd /tmp/ld-preload-open \
	&& sed -i 's/-Wall//' Makefile \
	&& sed -i -e 's/struct \([a-zA-Z_0-9]*\)64/struct \1/g' path-mapping.c \
	&& sed -i -e 's/.*\(define DISABLE_FTW\)/#\1/g' path-mapping.c \
	&& sed -i '1i#define __OPEN_NEEDS_MODE(oflag) (((oflag) & O_CREAT) != 0 || ((oflag) & O_TMPFILE) == O_TMPFILE)' path-mapping.c \
	&& make all

FROM alpine:latest
COPY --from=builder /tmp/ld-preload-open/path-mapping-quiet.so /opt/path-mapping-quiet.so
