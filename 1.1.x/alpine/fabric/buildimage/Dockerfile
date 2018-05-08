FROM docker:17.12.1-ce-rc2-dind

#ENV GO_VER=1.9.2
ENV NODE_VER=8.9.4

RUN apk update
RUN apk add git build-base make libltdl libtool unzip openjdk8 curl gcc musl-dev go=1.9.4-r0

RUN mkdir -p /opt/go && mkdir -p /opt/gopath

# install Go
#RUN cd /opt && curl https://dl.google.com/go/go${GO_VER}.linux-$(uname -m | sed 's|i686|386|' | sed 's|x86_64|amd64|').tar.gz | tar -xz

COPY *.sh /usr/bin/

ENV LD_LIBRARY_PATH=/usr/lib
ENV GOPATH=/opt/gopath
ENV GOROOT=/usr/lib/go
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin

ENTRYPOINT ["/usr/bin/run.sh"]
