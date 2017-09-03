#!/bin/bash

#!/bin/bash

cd /opt/grafana/

DB_PATH=/var/lib/grafana/grafana.db
SQL_PATH=${GRAFANA_SQL_PATH-/opt/grafana/sql}
GRAFANA_DS_ARR="$(echo ${GRAFANA_DATA_SOURCES} |sed -e 's/,/ /g')"

mkdir -p /var/lib/grafana
## Common SQL to get started
for db in $(ls ${SQL_PATH} |sort);do
    if [ -f ${SQL_PATH}/${db} ];then
        echo "[INFO] Parse '${SQL_PATH}/${db}'"
        cat ${SQL_PATH}/${db} | sqlite3 ${DB_PATH}
    fi
done
## sql within directories sources
for DPATH in $(find ${SQL_PATH} -type d -mindepth 1);do
    DNAME=$(basename ${DPATH})
    for DSPATH in $(find ${DPATH} -type f);do
        DSNAME=$(basename ${DSPATH} |awk -F\. '{print $1}' |sed -e 's/^[0-9\-]*//')
        if [[ "${DNAME}" == "data-sources" ]] && [[ " ${GRAFANA_DS_ARR[@]} " =~ " ${DSNAME} " ]] && [[ ${DSNAME} == "qcollect" ]] && [ "X${QCOLLECT_HOST}" != "X" ];then
            echo "[DEBUG] Exchange qcollect host -> ${QCOLLECT_HOST}"
            sed -i'' -e "s#http://influxdb:8086#${QCOLLECT_HOST}#" ${DSPATH}
        elif [[ "${DNAME}" == "data-sources" ]] && [[ " ${GRAFANA_DS_ARR[@]} " =~ " ${DSNAME} " ]] && [[ ${DSNAME} == "influxdb" ]] && [ "X${INFLUXDB_HOST}" != "Xnone" ] && [ "X${INFLUXDB_DB}" != "Xnone" ];then
            echo "[DEBUG] Exchange influxdb host -> ${INFLUXDB_HOST}"
            sed -i'' -e "s#INFLUXDB_HOST#${INFLUXDB_HOST}#g" ${DSPATH}
            echo "[DEBUG] Exchange influxdb db -> ${INFLUXDB_DB}"
            sed -i'' -e "s#INFLUXDB_DB#${INFLUXDB_DB}#g" ${DSPATH}
        elif [[ "${DNAME}" == "data-sources" ]] && [[ " ${GRAFANA_DS_ARR[@]} " =~ " ${DSNAME} " ]] && [[ ${DSNAME} == "prometheus" ]] && [ "X${PROMETHEUS_HOST}" != "Xnone" ] && [ "X${PROMETHEUS_PORT}" != "Xnone" ];then
            echo "[DEBUG] Exchange prometheus host -> ${PROMETHEUS_HOST}"
            sed -i'' -e "s#PROMETHEUS_HOST#${PROMETHEUS_HOST}#g" ${DSPATH}
            echo "[DEBUG] Exchange prometheus port -> ${PROMETHEUS_PORT}"
            sed -i'' -e "s#PROMETHEUS_PORT#${PROMETHEUS_PORT}#g" ${DSPATH}
        fi
        echo "[INFO] Parse '${DSPATH}'"
        cat ${DSPATH} | sqlite3 ${DB_PATH}
    done
done
