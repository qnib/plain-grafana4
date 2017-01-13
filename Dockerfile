FROM qnib/alplain-jre8

ARG GRAFANA_VER=4.1.0-1484127817
ENV GRAFANA_DATA_SOURCES=qcollect,elasticsearch

RUN apk --no-cache add sqlite openssl curl \
 && wget -qO - https://grafanarel.s3.amazonaws.com/builds/grafana-${GRAFANA_VER}.linux-x64.tar.gz |tar xfz - -C /opt/ \
 && mv /opt/grafana-${GRAFANA_VER} /opt/grafana
ADD etc/grafana/grafana.ini /etc/grafana/grafana.ini
ADD opt/qnib/grafana/bin/start.sh \
    opt/qnib/grafana/bin/healthcheck.sh \
    /opt/qnib/grafana/bin/
## SQL dumps to setup /var/lib/grafana/grafana.db
ADD opt/qnib/grafana/sql/00-migration_log.sql \
    opt/qnib/grafana/sql/10-user.sql \
    opt/qnib/grafana/sql/20-init-dash.sql \
    opt/qnib/grafana/sql/30-data-source.sql \
    opt/qnib/grafana/sql/40-backend.sql \
    /opt/qnib/grafana/sql/
ADD opt/qnib/grafana/sql/data-sources/prometheus.sql \
    opt/qnib/grafana/sql/data-sources/elasticsearch.sql \
    opt/qnib/grafana/sql/data-sources/qcollect.sql \
    /opt/qnib/grafana/sql/data-sources/
ADD opt/qnib/grafana/sql/dashboards/docker-stats.sql \
    opt/qnib/grafana/sql/dashboards/docker-engine.sql \
    opt/qnib/grafana/sql/dashboards/prometheus.sql \
    /opt/qnib/grafana/sql/dashboards/
CMD ["/opt/qnib/grafana/bin/start.sh"]
