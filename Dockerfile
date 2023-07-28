# build our final image
FROM amazoncorretto:8

LABEL maintainer "Michael Riffle <mriffle@uw.edu>"
LABEL comment "Based on work by Aaron Maurais -- MacCoss Lab"

ENV ENCYCLOPEDIA_VERSION='2.12.30'

ADD entrypoint.sh /usr/local/bin/entrypoint.sh
ADD binaries/percolator-3.01 /usr/local/bin/percolator

RUN yum install -y wget procps libgomp && \
    wget -O "/usr/local/bin/encyclopedia.jar" "https://bitbucket.org/searleb/encyclopedia/downloads/encyclopedia-$ENCYCLOPEDIA_VERSION-executable.jar" && \
    chmod 755 /usr/local/bin/entrypoint.sh && \
    chmod 755 /usr/local/bin/percolator && \
    yum clean all && \
    rm -rf /var/cache/yum

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD []
