FROM alpine:latest

RUN apk update
RUN apk add make
RUN apk add gcc
RUN apk add git
RUN apk add linux-headers ca-certificates musl-dev
# gcc git
RUN git clone --depth 1 https://github.com/maandree/libkeccak
WORKDIR libkeccak
RUN make
RUN make install
WORKDIR /
RUN git clone --depth 1 https://github.com/maandree/sha3sum
WORKDIR sha3sum
RUN make
RUN make install
ENTRYPOINT keccak-256sum
