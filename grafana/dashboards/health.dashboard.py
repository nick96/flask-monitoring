"""Main grafana dashboard.

This one tells us the state of each application (up, down, error,
etc.) and some basic health stats about them and the infrastructure
they're running on.

"""

import grafanalib.core as G

APPS = [
    {"name": "Flask App", "hostname": "flask-app", "port": 8000},
    {"name": "Prometheus", "hostname": "prometheus", "port": 9090},
    {"name": "Alertmanager", "hostname": "alertmanager", "port": 9093},
    {"name": "Grafana", "hostname": "grafana", "port": 3000},
]

dashboard = G.Dashboard(
    title="System health",
    rows=[
        G.Row(
            panels=[
                G.SingleStat(
                    title=app["name"],
                    dataSource="Prometheus",
                    description="",
                    targets=[
                        G.Target(
                            expr='up{{instance="{hostname}:{port}"}}'.format(
                                hostname=app["hostname"], port=app["port"]
                            )
                        )
                    ],
                    span=2,
                    thresholds="0.1",
                    transparent=True,
                    valueMaps=[
                        G.ValueMap(op="=", text="N/A", value="null"),
                        G.ValueMap(op="=", text="Down", value="0"),
                        G.ValueMap(op="=", text="Up", value="1"),
                    ],
                    valueName="current",
                    sparkline=G.SparkLine(
                        fillColor=G.RGBA(31, 118, 109, 0.18),
                        full=False,
                        lineColor=G.RGB(31, 120, 193),
                        show=False,
                    ),
                    gauge=G.Gauge(
                        maxValue=100,
                        minValue=0,
                        show=False,
                        thresholdLabels=False,
                        thresholdMarkers=True,
                    ),
                    maxDataPoints=100,
                    nullPointMode="connected",
                    rangeMaps=[G.RangeMap(start=None, text="N/A", end=None)],
                )
                for app in APPS
            ]
        )
    ],
).auto_panel_ids()
