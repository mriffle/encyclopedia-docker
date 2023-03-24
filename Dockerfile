FROM ubuntu:20.04 AS builder

LABEL maintainer "Michael Riffle <mriffle@uw.edu>"
LABEL comment "Based on work by Aaron Maurais -- MacCoss Lab"

ENV PERCOLATOR_VERSION='3-01'
ENV ENCYCLOPEDIA_VERSION='2.12.30'
ENV DEBIAN_FRONTEND='noninteractive'
ENV TZ='Etc/UTC'

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install build-essential cmake libgomp1 wget && \
    apt-get clean

RUN mkdir /code

# build percolator
ENV PERCOLATOR_VERSION='3-01'
RUN cd /code && mkdir percolator && cd percolator \
    && wget https://github.com/percolator/percolator/archive/refs/tags/rel-"$PERCOLATOR_VERSION".tar.gz \
    && tar xf rel-"$PERCOLATOR_VERSION".tar.gz \
    && cd percolator-rel-"$PERCOLATOR_VERSION" \
    && cmake . && make

# fetch encyclopedia
RUN cd /code; wget -O "encyclopedia.jar" "https://bitbucket.org/searleb/encyclopedia/downloads/encyclopedia-$ENCYCLOPEDIA_VERSION-executable.jar"

# build our final image
FROM amazoncorretto:8

LABEL maintainer "Michael Riffle <mriffle@uw.edu>"
LABEL comment "Based on work by Aaron Maurais -- MacCoss Lab"

COPY --from=builder /code/percolator  /usr/local/bin/percolator
COPY --from=builder /code/encyclopedia.jar /usr/local/bin/encyclopedia.jar

ADD entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod 755 /usr/local/bin/entrypoint.sh && \
    chmod 755 /usr/local/bin/percolator && \
    yum install -y procps && \
    yum clean all && \
    rm -rf /var/cache/yum

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD []
