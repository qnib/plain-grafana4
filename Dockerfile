FROM qnib/alplain-jre8

ARG GRAFANA_VER=4.2.0
ENV GRAFANA_DATA_SOURCES=qcollect,elasticsearch

RUN apk --no-cache add sqlite openssl curl \
 && wget -qO - https://grafanarel.s3.amazonaws.com/builds/grafana-${GRAFANA_VER}.linux-x64.tar.gz |tar xfz - -C /opt/ \
 && mv /opt/grafana-${GRAFANA_VER} /opt/grafana
ADD etc/grafana/grafana.ini /etc/grafana/grafana.ini
ADD opt/qnib/grafana/bin/healthcheck.sh \
    opt/qnib/grafana/bin/backup_dash.sh \
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
RUN /opt/grafana/bin/grafana-cli plugins install jdbranham-diagram-panel
RUN /opt/grafana/bin/grafana-cli plugins install savantly-heatmap-panel
RUN /opt/grafana/bin/grafana-cli plugins install hawkular-datasource
RUN /opt/grafana/bin/grafana-cli plugins install vonage-status-panel
RUN /opt/grafana/bin/grafana-cli plugins install crate-datasource
ADD opt/qnib/env/grafana/api_key.sh /opt/qnib/env/grafana/
ADD opt/qnib/grafana/sql/api_keys/viewer.sql /opt/qnib/grafana/sql/api_keys/
CMD ["/opt/grafana/bin/grafana-server", "--pidfile=/var/run/grafana-server.pid", "--config=/etc/grafana/grafana.ini", "cfg:default.paths.data=/var/lib/grafana", "cfg:default.paths.logs=/var/log/grafana"]
