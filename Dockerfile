FROM ubuntu:16.04

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y wget git curl \
  && apt-get install -y build-essential

RUN set -eux; \
	url="https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz"; \
	wget -O go.tgz "$url"; \
	tar -C /usr/local -xzf go.tgz; \
	rm go.tgz; \
	\
	export PATH="/usr/local/go/bin:$PATH"; \
	go version

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH


ARG branch=develop
RUN git clone -b $branch https://github.com/second-state/devchain.git --recursive --depth 1 $GOPATH/src/github.com/second-state/devchain

# libeni
ENV LIBENI_PATH=/app/lib
RUN mkdir -p libeni \
  && wget https://github.com/second-state/libeni/releases/download/v1.3.6/libeni-1.3.6_ubuntu-16.04.tgz -P libeni \
  && tar zxvf libeni/*.tgz -C libeni \
  && mkdir -p $LIBENI_PATH && cp libeni/*/lib/* $LIBENI_PATH


WORKDIR $GOPATH/src/github.com/second-state/devchain
RUN ENI_LIB=$LIBENI_PATH make build
RUN make install

WORKDIR /app
ENV ENI_LIBRARY_PATH=/app/lib
ENV LD_LIBRARY_PATH=/app/lib

EXPOSE 8545 26656 26657

ENTRYPOINT ["/go/bin/devchain"]