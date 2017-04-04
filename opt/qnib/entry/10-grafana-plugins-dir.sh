#!/bin/bash

sed -i'' -e 's#plugins = .*#plugins = plugins#' /opt/grafana/conf/defaults.ini
