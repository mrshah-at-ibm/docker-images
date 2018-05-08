#FROM alpine
FROM golang:1.10-alpine
RUN apk update
RUN apk add git build-base make libltdl libtool unzip openjdk8 curl gcc musl-dev
COPY setup.sh /setup.sh
RUN /setup.sh
ENV LD_LIBRARY_PATH=/usr/lib;/usr/include
ENV GOPATH=/opt/gopath GOROOT=/usr/local/go
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin
