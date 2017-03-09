FROM erlang:19.2.3
MAINTAINER Heinz N. Gies <heinz@project-fifo.net>

###################
##
## Get DalmatinerFE
##
###################

ENV DP_VSN=0.3.1p4
ENV DP_PATH=/ddb_proxy
ENV DP_REF=$DP_VSN

RUN cd / \
    && env GIT_SSL_NO_VERIFY=true git clone -b $DP_VSN http://github.com/dalmatinerdb/ddb_proxy.git ddb_proxy.git

RUN cd ddb_proxy.git \
    && env GIT_SSL_NO_VERIFY=true git checkout $DP_REF \
    && make rel \
    && mv /ddb_proxy.git/_build/prod/rel/ddb_proxy $DP_PATH \
    && rm -rf $DP_PATH/lib/*/c_src \
    && cd / \
    && rm -rf /ddb_proxy.git

RUN mkdir -p /data/ddb_proxy/db \
    && mkdir -p /data/ddb_proxy/etc \
    && mkdir -p /data/ddb_proxy/log \
    && cp $DP_PATH/etc/ddb_proxy.conf.example /data/ddb_proxy/etc/ddb_proxy.conf \
    && sed -i -e 's/idx.backend = dqe_idx_ddb/idx.backend = dqe_idx_pg/' /data/ddb_proxy/etc/ddb_proxy.conf \
    && echo "listeners.dp_graphite.bucket = graphite" >> /data/ddb_proxy/etc/ddb_proxy.conf \
    && echo "listeners.dp_graphite.port = 2003" >> /data/ddb_proxy/etc/ddb_proxy.conf \
    && echo "listeners.dp_graphite.protocol = tcp" >> /data/ddb_proxy/etc/ddb_proxy.conf \
    && echo "listeners.dp_otsdb.bucket = otsdb" >> /data/ddb_proxy/etc/ddb_proxy.conf \
    && echo "listeners.dp_otsdb.port = 4242" >> /data/ddb_proxy/etc/ddb_proxy.conf \
    && echo "listeners.dp_otsdb.protocol = tcp" >> /data/ddb_proxy/etc/ddb_proxy.conf \
    && echo "listeners.dp_bsdsyslog.bucket = syslog" >> /data/ddb_proxy/etc/ddb_proxy.conf \
    && echo "listeners.dp_bsdsyslog.port = 9999" >> /data/ddb_proxy/etc/ddb_proxy.conf \
    && echo "listeners.dp_bsdsyslog.protocol = udp" >> /data/ddb_proxy/etc/ddb_proxy.conf \
    && echo "listeners.dp_prom_writer.bucket = promwriter" >> /data/ddb_proxy/etc/ddb_proxy.conf \
    && echo "listeners.dp_prom_writer.port = 1234" >> /data/ddb_proxy/etc/ddb_proxy.conf \
    && echo "listeners.dp_prom_writer.protocol = http" >> /data/ddb_proxy/etc/ddb_proxy.conf \
    && sed -i -e '/RUNNER_USER=dalmatiner/d' $DP_PATH/bin/ddb_proxy


COPY ddb_proxy.sh /

EXPOSE 8086
EXPOSE 2003
EXPOSE 4242
EXPOSE 9999
EXPOSE 1234

ENTRYPOINT ["/ddb_proxy.sh"]
