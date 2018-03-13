#!/bin/bash
set -e

set -x

CONF=/data/dalmatinerfe/etc/dalmatinerfe.conf


sed -i \
    -e "s/^ddb_connection.backend_host = .*/ddb_connection.backend_host = ${DB_NODE}/" \
    -e "s/^idx.pg.backend_host = .*/idx.pg.backend_host = ${PG_NODE}/" \
    $CONF

LOG=/data/dalmatinerfe/log/console.log
> $LOG
/dalmatinerfe/bin/dalmatinerfe start
tail -n 1024 -f $LOG
