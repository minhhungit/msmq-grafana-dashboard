# MSQM grafana dashboard - MSMQ Grafana Exporter


## Demo

![image](https://github.com/minhhungit/msmq-grafana-dashboard/assets/2279508/86e6f2af-7a6c-46d8-a680-f8a1cce937b1)


## Install msmq exporter as windows service
use [NSSM](https://nssm.cc/download) tool

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

![image](https://github.com/minhhungit/msmq-grafana-dashboard/assets/2279508/d4df8adc-2b2a-4122-8234-9c74ac028f06)


## Import granafa dashboard
- From [dashboard.json](https://github.com/minhhungit/msmq-grafana-dashboard/blob/main/dashboard.json)
- Or from grafana dashboard page: https://grafana.com/grafana/dashboards/21439-microsoft-message-queue-msmq/

