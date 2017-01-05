#!/bin/bash

cd /opt/grafana/

DB_PATH=/var/lib/grafana/grafana.db
SQL_PATH=${GRAFANA_SQL_PATH-/opt/qnib/grafana/sql}
mkdir -p /var/lib/grafana
## Common SQL to get started
for db in $(ls ${SQL_PATH} |sort);do
    if [ -f ${SQL_PATH}/${db} ];then
        cat ${SQL_PATH}/${db} | sqlite3 ${DB_PATH}
    fi
done
## data sources
if [ "X${GRAFANA_DATA_SOURCES}" != "X" ];then
    for ds in $(echo ${GRAFANA_DATA_SOURCES} |sed -e 's/,/ /g');do
        if [ -f ${SQL_PATH}/data-sources/${ds}.sql ];then
            if [ ${ds} == "qcollect" ] && [ "X${QCOLLECT_HOST}" != "X" ];then
                echo "[INFO] Exchange qcoolect host -> ${QCOLLECT_HOST}" 
                sed -i'' -e "s#http://influxdb:8086#${QCOLLECT_HOST}#" ${SQL_PATH}/data-sources/${ds}.sql
            fi
            echo "[INFO] Parse '${SQL_PATH}/data-sources/${ds}.sql'"
            cat ${SQL_PATH}/data-sources/${ds}.sql | sqlite3 /var/lib/grafana/grafana.db
        else
            echo "[ERROR] Could not find '${SQL_PATH}/data-sources/${ds}.sql'"
        fi
    done
fi

### inserts dashboards
for dash in $(ls ${SQL_PATH}/dashboards/);do
    echo "[INFO] Parse '${SQL_PATH}/dashboards/${dash}'"
    cat ${SQL_PATH}/dashboards/${dash} | sqlite3 /var/lib/grafana/grafana.db
done

sleep 1
/opt/grafana/bin/grafana-server --pidfile=/var/run/grafana-server.pid --config=/etc/grafana/grafana.ini cfg:default.paths.data=/var/lib/grafana cfg:default.paths.logs=/var/log/grafana
