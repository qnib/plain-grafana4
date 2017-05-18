#!/bin/bash

######
mkdir -p /opt/grafana/sql/{data-sources,dashboards}
# In case /opt/qnib/grafana/sql/ is empty this will bootstrap with the basic set up sql statements
if [[ $(find /opt/grafana/sql -type f |wc -l) -eq 0 ]];then
    cp $(find /opt/qnib/grafana/sql/ -type f |xargs -n1) /opt/grafana/sql/
fi
if [[ $(find /opt/grafana/sql/data-sources -type f |wc -l) -eq 0 ]];then
    cp $(find /opt/qnib/grafana/sql/data-sources -type f |xargs -n1) /opt/grafana/sql/data-sources/
fi
if [[ $(find /opt/grafana/sql/dashboards -type f |wc -l) -eq 0 ]];then
    cp $(find /opt/qnib/grafana/sql/dashboards -type f |xargs -n1) /opt/grafana/sql/dashboards/
fi
