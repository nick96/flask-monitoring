route:
    receiver: 'slack'

receivers:
    - name: 'slack'
      slack_configs:
          - send_resolved: true
            username: 'hera-alertmanager'
            channel: '#alerts'
            api_url: "${web_hook_uri}"
