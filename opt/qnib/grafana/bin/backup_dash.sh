#!/bin/bash

ITEMS=$1
if [[ -z ${ITEMS} ]];then
   ITEMS=$(sqlite3 /var/lib/grafana/grafana.db .dump |egrep -o "INSERT INTO \"dashboard\" VALUES\(.*',X" |awk -F, '{print $3}' |tr -d \ |xargs | sed -e 's/ /,/g')
fi
for item in $(echo ${ITEMS} |sed -e 's/,/ /g');do
    if [[ -n ${BACKUP_DIR} ]];then
        sqlite3 /var/lib/grafana/grafana.db .dump | egrep "INSERT INTO \"dashboard\".*${item}" > ${BACKUP_DIR}/${item}.sql
    else
        sqlite3 /var/lib/grafana/grafana.db .dump | egrep "INSERT INTO \"dashboard\".*${item}" 
    fi
done
