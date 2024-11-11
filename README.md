# MSQM grafana dashboard - MSMQ Grafana Exporter

This project provides a Grafana dashboard to monitor Microsoft Message Queue (MSMQ) metrics using a Prometheus exporter. The exporter can be installed as a Windows service using the NSSM tool.

## Screenshot
![image](https://github.com/user-attachments/assets/11d92619-db4b-47ee-9983-c3f008bbe3ed)


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

![image](https://github.com/user-attachments/assets/e67c9ca2-4c8a-4b6e-912a-7134ebf3edb2)


6. Start service
   ```sh
   nssm start msmq_exporter
   ```

7. After install and start windows service, check http://localhost:9188/metrics to see if it works or not
   

## Prometheus Configuration

To configure Prometheus to scrape metrics from the MSMQ exporter, add the following job configuration to your `prometheus.yml` file:

```yaml
- job_name: 'msmq_exporter'
  static_configs:
    - targets: ['WEBSERVICE001:9188'] 
      labels:
        hostname: WEBSERVICE001
        type: windows
        company: Jin
```

![image](https://github.com/user-attachments/assets/a3747372-2a54-4305-a691-071dd52b53c4)


## Import Grafana Dashboard
Use .json file
Download the dashboard.json file from this repository.
Open Grafana and navigate to the dashboard import page.
Upload the [dashboard-v2.json](https://github.com/minhhungit/msmq-grafana-dashboard/blob/main/dashboard-v2.json) file.

## Contributing
If you have any suggestions or improvements, feel free to create an issue or submit a pull request.
