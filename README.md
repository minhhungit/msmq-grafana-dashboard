# MSQM grafana dashboard - MSMQ Grafana Exporter

This project provides a Grafana dashboard to monitor Microsoft Message Queue (MSMQ) metrics using a Prometheus exporter. The exporter can be installed as a Windows service using the NSSM tool.

## Screenshot
![image](https://github.com/minhhungit/msmq-grafana-dashboard/assets/2279508/086c22ff-b545-486e-b37f-3d11dbb4b668)


## Installation

### Install MSMQ Exporter as a Windows Service

To install the MSMQ exporter as a Windows service, we recommend using the NSSM (Non-Sucking Service Manager) tool.

1. Download NSSM from [https://nssm.cc/download](https://nssm.cc/download).
2. Extract the downloaded archive.
3. Open powershell as an administrator on the extracted folder
4. Run the following commands to install the MSMQ exporter as a service:

    ```sh
    .\nssm install msmq_exporter
    ```
5. Config like bellow image
![image](https://github.com/minhhungit/msmq-grafana-dashboard/assets/2279508/41b75208-40f5-49c6-ae9f-dc618ab7f36f)

6. Start service
   ```sh
   nssm install msmq_exporter
   ```

7. After install and start windows service, check http://localhost:9184/metrics to see if it works or not
   

## Prometheus Configuration

To configure Prometheus to scrape metrics from the MSMQ exporter, add the following job configuration to your `prometheus.yml` file:

```yaml
- job_name: 'msmq_exporter'
  static_configs:
    - targets: ['WEBSERVICE001:9184'] 
      labels:
        hostname: WEBSERVICE001
        type: windows
        company: Jin
```

![image](https://github.com/minhhungit/msmq-grafana-dashboard/assets/2279508/d4df8adc-2b2a-4122-8234-9c74ac028f06)

## Import Grafana Dashboard
To import the Grafana dashboard, you have two options:

### Option 1: From dashboard.json
Download the dashboard.json file from this repository.
Open Grafana and navigate to the dashboard import page.
Upload the [dashboard.json](https://github.com/minhhungit/msmq-grafana-dashboard/blob/main/dashboard.json) file.

### Option 2: From Grafana Dashboard Page
Open Grafana and navigate to the dashboard import page.
Enter ID `21439` [https://grafana.com/grafana/dashboards/21439-msmq-w-powershell/](https://grafana.com/grafana/dashboards/21439-msmq-w-powershell/)
Click "Load" and follow the prompts to complete the import.

![image](https://github.com/minhhungit/msmq-grafana-dashboard/assets/2279508/9d99340d-c31f-4c7c-96fe-f92ce99dbddb)

## Contributing
If you have any suggestions or improvements, feel free to create an issue or submit a pull request.
