FROM python:3.7-stretch as generation

WORKDIR /dashboard-generation

COPY ./dashboards/requirements.txt requirements.txt
COPY ./dashboards/*.py .
RUN pip install -r requirements.txt
RUN for py in $(ls *.py); do generate-dashboard -o "$(basename $py).json" $py; done

FROM grafana/grafana:6.0.2

COPY grafana.ini /etc/grafana/
COPY dashboards.yml /etc/grafana/provisioning/dashboards/all.yml
COPY datasources.yml /etc/grafana/provisioning/datasources/all.yml
COPY --from=generation /dashboard-generation/*.json /grafana/dashboards/

ENTRYPOINT ["grafana-server", "--homepath=/usr/share/grafana", "--config=/etc/grafana/grafana.ini"]
