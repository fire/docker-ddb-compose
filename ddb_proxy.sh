#!/bin/bash
set -e

set -x

CONF=/data/dalmatinerpx/etc/dalmatinerpx.conf

export DB_HOST=$(ping -c1 $DB_NODE | awk '/^PING/ {print $3}' | sed 's/[():]//g')||'127.0.0.1'

sed -i \
    -e "s/^ddb_connection.backend_host = .*/ddb_connection.backend_host = ${DB_HOST}/" \
    -e "s/^idx.pg.backend_host = .*/idx.pg.backend_host = ${PG_NODE}/" \
    $CONF

LOG=/data/dalmatinerpx/log/console.log
> $LOG
/dpx/bin/dpx start
tail -n 1024 -f $LOG
