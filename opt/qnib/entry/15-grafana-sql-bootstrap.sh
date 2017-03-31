#!/bin/bash

###### 
# In case /opt/qnib/grafana/sql/ is empty this will bootstrap with the basic set up sql statements
if [[ $(find /opt/grafana/sql -type f |wc -l) -eq 0 ]];then
    rsync -aP /opt/qnib/grafana/sql/. /opt/grafana/sql/.
fi
