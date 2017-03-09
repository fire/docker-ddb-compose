FROM erlang:19.2.3
MAINTAINER Heinz N. Gies <heinz@project-fifo.net>

###################
##
## Get DalmatinerFE
##
###################

ENV DFE_VSN=0.3.1p1
ENV DFE_PATH=/dalmatinerfe
ENV DFE_REF=$DFE_VSN

RUN cd / \
    && env GIT_SSL_NO_VERIFY=true git clone http://github.com/dalmatinerdb/dalmatiner-frontend.git dalmatiner-frontend.git

Run cd dalmatiner-frontend.git \
    && env GIT_SSL_NO_VERIFY=true git checkout $DFE_VSN \
    && make rel \
    && mv /dalmatiner-frontend.git/_build/prod/rel/dalmatinerfe $DFE_PATH \
    && rm -rf /dalmatiner-frontend.git \
    && rm -rf $DFE_PATH/lib/*/c_src

RUN cd / \
    && mkdir -p /data/dalmatinerfe/etc \
    && mkdir -p /data/dalmatinerfe/db \
    && mkdir -p /data/dalmatinerfe/log \
    && cp $DFE_PATH/etc/dalmatinerfe.conf.example /data/dalmatinerfe/etc/dalmatinerfe.conf \
    && sed -i -e '/RUNNER_USER=dalmatiner/d' $DFE_PATH/bin/dalmatinerfe \
    && sed -i -e 's/idx.backend = dqe_idx_ddb/idx.backend = dqe_idx_pg/' /data/dalmatinerfe/etc/dalmatinerfe.conf

COPY dfe.sh /

EXPOSE 8080

ENTRYPOINT ["/dfe.sh"]
