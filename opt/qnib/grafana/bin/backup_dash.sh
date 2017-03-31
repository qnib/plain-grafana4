#!/bin/bash

BACKUP_DIR=$1

for item in $(sqlite3 /var/lib/grafana/grafana.db .dump |egrep -o "INSERT INTO \"dashboard\" VALUES\(.*',X" |awk -F, '{print $3}' |tr -d \ |xargs);do
    if [[ -n ${BACKUP_DIR} ]];then
        sqlite3 /var/lib/grafana/grafana.db .dump | egrep "INSERT INTO \"dashboard\".*${item}" > ${BACKUP_DIR}/${item}.sql
    else
        sqlite3 /var/lib/grafana/grafana.db .dump | egrep "INSERT INTO \"dashboard\".*${item}"
    fi
done
