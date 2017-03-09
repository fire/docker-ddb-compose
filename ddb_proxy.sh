#!/bin/bash
set -e

set -x

CONF=/data/ddb_proxy/etc/ddb_proxy.conf

export DB_HOST=$(ping -c1 $DB_NODE | awk '/^PING/ {print $3}' | sed 's/[():]//g')||'127.0.0.1'

sed -i \
    -e "s/^ddb_connection.backend_host = .*/ddb_connection.backend_host = ${DB_HOST}/" \
    -e "s/^idx.pg.backend_host = .*/idx.pg.backend_host = ${PG_NODE}/" \
    $CONF

LOG=/data/ddb_proxy/log/console.log
> $LOG
/ddb_proxy/bin/ddb_proxy start
tail -n 1024 -f $LOG
