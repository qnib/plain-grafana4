#!/bin/bash


######
mkdir -p /opt/grafana/sql/{data-sources,dashboards}
# In case /opt/qnib/grafana/sql/ is empty this will bootstrap with the basic set up sql statements
if [[ $(find /opt/grafana/sql -type f -maxdepth 1 |wc -l) -eq 0 ]];then
    echo "> Boostrap /opt/grafana/sql/"
    cp $(find /opt/qnib/grafana/sql/ -type f -maxdepth 1 |xargs -n1) /opt/grafana/sql/
fi
if [[ $(find /opt/grafana/sql/data-sources -type f -maxdepth 1 |wc -l) -eq 0 ]];then
    echo "> Boostrap /opt/grafana/sql/data-sources"
    cp $(find /opt/qnib/grafana/sql/data-sources -type f -maxdepth 1 |xargs -n1) /opt/grafana/sql/data-sources/
fi
if [[ $(find /opt/grafana/sql/dashboards -type f -maxdepth 1 |wc -l) -eq 0 ]];then
    echo "> Boostrap /opt/grafana/sql/dashboards"
    cp $(find /opt/qnib/grafana/sql/dashboards -type f -maxdepth 1 |xargs -n1) /opt/grafana/sql/dashboards/
fi
