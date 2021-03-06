FROM ubuntu:18.04

ARG DONATE_LEVEL=0
ARG GIT_TAG

WORKDIR /app
USER root

RUN apt-get update
RUN apt-get install -y software-properties-common
#RUN add-apt-repository -y ppa:jonathonf/gcc-7.1
RUN apt-get update
RUN apt-get install -y gcc-7 g++-7 git build-essential cmake libuv1-dev libmicrohttpd-dev libssl-dev libhwloc-dev msr-tools

RUN git clone https://github.com/xmrig/xmrig.git
WORKDIR /app/xmrig
RUN git checkout $GIT_TAG

# Adjust donation level
RUN sed -i -r "s/k([[:alpha:]]*)DonateLevel = [[:digit:]]/k\1DonateLevel = ${DONATE_LEVEL}/g" src/donate.h

RUN mkdir build
WORKDIR /app/xmrig/build
RUN cmake .. -DCMAKE_C_COMPILER=gcc-7 -DCMAKE_CXX_COMPILER=g++-7
RUN make
COPY config.json /app/xmrig/build

CMD ./xmrig -c $XMRIG_JSON_CONFIG_PATH
