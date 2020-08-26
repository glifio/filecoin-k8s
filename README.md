# filecoin-k8s
Repo for configuring and controlling the Filecoin Kubernetes cluster monitoring

## Basic spinup for monitoring components
#### Requirements:
- helm v3.2+
- create slack webhook in your slack workspace, paste in **Makefile** `SLACK-WEBHOOK-URL`
- create or have public slack channel for alert messages, change it in **Makefile**  `SLACK-CHANNEL`
- change nodeselector label in `values.yaml`, if your nodes don't have `role: monitoring` labels
- chage lotus node labels in `values.yaml` in `additionalServiceMonitors` section, if your lotus application doesn't use `app: lotus-node-app` label
- deploy ingress controller 
- provide external dns name for grafana dashboard, change it in **Makefile**  `GRAFANA-HOST`
- generate password for grafana dashboard login(login admin), change it in **Makefile**  `GRAFANA-WEB-PASSWORD`

Default settings( may be changed in **Makefile** or in **values.yaml** ):
- helm chart name: monitoring
- monitoring namespace: monitoring(will be created and used)
- lotus node namespace: calibrationnet(you may change it to your own in file **values.yaml** in section `prometheus.prometheusSpec.additionalServiceMonitors.namespaceSelector.matchNames`)

### Deploy monitoring

    make create-monitoring

### Upgrade monitoring
    
    change parameters in values.yaml or customize Makefile with --set variable
    make upgrade-monitoring
    

## General usage
Once they are both spun up, you can login to grafana and choose necessary dashboard.

If you want to open prometheus, alertmanager ui locally , you may use `kubectl proxy`

**Prometheus**

    http://127.0.0.1:8001/api/v1/namespaces/monitoring/services/prometheus-operated:9090/proxy

**Alertmanager**

    http://127.0.0.1:8001/api/v1/namespaces/monitoring/services/alertmanager-operated:9093/proxy/