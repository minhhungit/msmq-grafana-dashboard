# MSQM grafana dashboard - MSMQ Grafana Exporter

## Setup msmq exporter as windows service
use NSSM tool

![image](https://github.com/minhhungit/msmq-grafana-dashboard/assets/2279508/41b75208-40f5-49c6-ae9f-dc618ab7f36f)

## Prometheus config:
```yml
- job_name: 'msmq_exporter'
    static_configs:
    
    - targets: ['webservice001:9184'] 
      labels:
       hostname: WEBSERVICE001
       type: windows
       company: Jin
```

![image](https://github.com/minhhungit/msmq-grafana-dashboard/assets/2279508/9f0f5134-b610-41bc-9513-0a3fe7800ff8)

## Import granafa dashboard
- From [dashboard.json](https://github.com/minhhungit/msmq-grafana-dashboard/blob/main/dashboard.json)
- Or from grafana dashboard page: https://grafana.com/grafana/dashboards/21439-microsoft-message-queue-msmq/
