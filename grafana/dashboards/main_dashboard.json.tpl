{
    "annotations": {
	"list": []
    },
    "description": "Starter setup for local development.",
    "editable": true,
    "gnetId": null,
    "graphTooltip": 0,
    "hideControls": false,
    "links": [],
    "refresh": "5s",
    "rows": [
	{
	    "collapse": false,
	    "height": "100",
	    "panels": [
		    %{ for app in split(",", apps) }
		{
		    "cacheTimeout": null,
		    "colorBackground": true,
		    "colorValue": false,
		    "colors": [
			"rgba(245, 54, 54, 0.9)",
			"rgba(237, 129, 40, 0.89)",
			"rgba(50, 172, 45, 0.97)"
		    ],
		    "datasource": "Prometheus",
		    "description": "",
		    "format": "none",
		    "gauge": {
			"maxValue": 100,
			"minValue": 0,
			"show": false,
			"thresholdLabels": false,
			"thresholdMarkers": true
		    },
		    "hideTimeOverride": false,
		    "interval": null,
		    "links": [],
		    "mappingType": 1,
		    "mappingTypes": [
			{
			    "name": "value to text",
			    "value": 1
			},
			{
			    "name": "range to text",
			    "value": 2
			}
		    ],
		    "maxDataPoints": 100,
		    "nullPointMode": "connected",
		    "nullText": null,
		    "postfix": "",
		    "postfixFontSize": "50%",
		    "prefix": "",
		    "prefixFontSize": "50%",
		    "rangeMaps": [
			{
			    "from": "null",
			    "text": "N/A",
			    "to": "null"
			}
		    ],
		    "span": 2,
		    "sparkline": {
			"fillColor": "rgba(31, 118, 189, 0.18)",
			"full": false,
			"lineColor": "rgb(31, 120, 193)",
			"show": false
		    },
		    "targets": [
			{
			    "expr": "up{instance=\"${app}\"}",
			    "intervalFactor": 2,
			    "legendFormat": "",
			    "refId": "A",
			    "step": 4
			}
		    ],
		    "thresholds": "0,1",
		    "title": "${split(":", app)[0]}",
		    "transparent": true,
		    "type": "singlestat",
		    "valueFontSize": "80%",
		    "valueMaps": [
			{
			    "op": "=",
			    "text": "N/A",
			    "value": "null"
			},
			{
			    "op": "=",
			    "text": "Down",
			    "value": "0"
			},
			{
			    "op": "=",
			    "text": "Up",
			    "value": "1"
			}
		    ],
		    "valueName": "current"
		}
		    %{ if app != split(",", apps)[length(split(",", apps)) - 1] }
		,
		    %{ endif }

		    %{endfor }
	    ],
	    "repeat": null,
	    "repeatIteration": null,
	    "repeatRowId": null,
	    "showTitle": true,
	    "title": "Service Metrics Status",
	    "titleSize": "h6"
	},
	{
	    "collapse": false,
	    "height": 250,
	    "panels": [
		{
		    "aliasColors": {},
		    "bars": false,
		    "datasource": null,
		    "fill": 1,
		    "id": 8,
		    "legend": {
			"avg": false,
			"current": false,
			"max": false,
			"min": false,
			"show": true,
			"total": false,
			"values": false
		    },
		    "lines": true,
		    "linewidth": 1,
		    "links": [],
		    "nullPointMode": "null",
		    "percentage": false,
		    "pointradius": 5,
		    "points": false,
		    "renderer": "flot",
		    "seriesOverrides": [],
		    "span": 12,
		    "stack": false,
		    "steppedLine": false,
		    "targets": [
			{
			    "expr": "histogram_quantile(0.99, sum(rate(request_processing_seconds_bucket[1m])) by (le))",
			    "intervalFactor": 2,
			    "legendFormat": "",
			    "metric": "",
			    "refId": "A",
			    "step": 2
			}
		    ],
		    "thresholds": [],
		    "timeFrom": null,
		    "timeShift": null,
		    "title": "Request processing time",
		    "tooltip": {
			"shared": true,
			"sort": 0,
			"value_type": "individual"
		    },
		    "transparent": true,
		    "type": "graph",
		    "xaxis": {
			"mode": "time",
			"name": null,
			"show": true,
			"values": []
		    },
		    "yaxes": [
			{
			    "format": "short",
			    "label": null,
			    "logBase": 1,
			    "max": null,
			    "min": null,
			    "show": true
			},
			{
			    "format": "short",
			    "label": null,
			    "logBase": 1,
			    "max": null,
			    "min": null,
			    "show": false
			}
		    ]
		}
	    ],
	    "repeat": null,
	    "repeatIteration": null,
	    "repeatRowId": null,
	    "showTitle": false,
	    "title": "Dashboard Row",
	    "titleSize": "h6"
	}
    ],
    "schemaVersion": 14,
    "style": "dark",
    "tags": [],
    "templating": {
	"list": []
    },
    "time": {
	"from": "now-5m",
	"to": "now"
    },
    "timepicker": {
	"refresh_intervals": [
	    "5s",
	    "10s",
	    "30s",
	    "1m",
	    "5m",
	    "15m",
	    "30m",
	    "1h",
	    "2h",
	    "1d"
	],
	"time_options": [
	    "5m",
	    "15m",
	    "1h",
	    "6h",
	    "12h",
	    "24h",
	    "2d",
	    "7d",
	    "30d"
	]
    },
    "timezone": "browser",
    "title": "Local Starter",
    "version": 1
}
