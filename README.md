# filecoin-k8s
Repo for configuring and controlling the Filecoin Kubernetes cluster

## Basic spinup for monitoring components

### Prepare the cluster

Create the monitoring namespace:

    kubectl apply -f monitoring/namespace.yaml

### Deploy Prometheus

    helm install stable/prometheus --name-template prometheus --namespace monitoring --values grafana/values.yam

### Deploy Grafana

    # Create the config map so grafana can discover prometheus
    kubectl apply -f monitoring/grafana/config.yaml

    # Deploy it
    helm install stable/grafana --name-template grafana --namespace monitoring --values grafana/values.yaml

## General usage
Once they are both spun up, you can portmap to each to see stats. 

### Prometheus

Map the port for prometheus:

    kubectl port-forward pod/prometheus-server-$UNIQUE_IDENTIFIER_HERE 9090:9090 --namespace monitoring

Open `127.0.0.1:9090` in your local web browser. 

### Grafana:

    kubectl port-forward grafana-$UNIQUE_IDENTIFIER_HERE 3000:3000 --namespace monitoring

To get the grafana admin password, run the following command:

    kubectl get secret \
    --namespace monitoring grafana \
    -o jsonpath="{.data.admin-password}" \
    | base64 --decode ; echo


Open `127.0.0.1:3000` in your local web browser and log in using `admin` and the password retrieved in the prior command

#### Adding dashboards from grafana.com


Edit monitoring/grafana/values.yaml and find the following block


    dashboards:
      default:


Under the default key, add the config for the dashbaod you want to pull from grafana.com:

    prometheus-2:
      gnetId: 3662
      revision: 2
      datasource: Prometheus

 Upgrade via helm:

    helm upgrade --install grafana stable/grafana \
        -f monitoring/grafana/values.yaml \
        --namespace monitoring

The dashboad should now appear in grafana

Example dashboards:

https://grafana.com/grafana/dashboards/1860

#### Adding custom dashboards

To add custom dashboards, create them in grafana, export the JSON and then upload them to grafana.com. Then, using the above directions, add a config to add the dashboard to the helm chart.


### Resources ###

Huge thanks to Christaan Vermeulen for his post: https://medium.com/@chris_linguine/how-to-monitor-your-kubernetes-cluster-with-prometheus-and-grafana-2d5704187fc8