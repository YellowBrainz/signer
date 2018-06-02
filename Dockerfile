FROM alpine:latest

RUN \
 apk add --update git make gcc musl-dev linux-headers ca-certificates && \
  git clone --depth 1 https://github.com/maandree/libkeccak && \
  (cd libkeccak && make && make install) && \
  rm -rf libkeccak && \
  git clone --depth 1 https://github.com/maandree/sha3sum && \
  (cd sha3sum && make && make install) && \
  rm -rf sha3sum && \
  apk del git make gcc musl-dev linux-headers && \
  rm -rf /var/cache/apk/*

WORKDIR /opt
VOLUME /opt
ENTRYPOINT ["/usr/local/bin/keccak-256sum"]
CMD ["--help"]
