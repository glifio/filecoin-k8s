#helm installation name
NAME = monitoring
#namespace to install monitoring
NAMESPACE = monitoring
#version prometheus-operator helm chart
VERSION-PROM-OPERATOR = 9.3.0
#grafana external hostname
GRAFANA-HOST = "example.local"
#admin user password in grafana
GRAFANA-WEB-PASSWORD = "CHANGEME"
SLACK-WEBHOOK-URL = "https://hooks.slack.com/"CHANGEME""
#notification channel name in slack. do not delete "\". it screens "#"
SLACK-CHANNEL = "\#CHANGEME"

.PHONY:
upgrade-monitoring:
	helm upgrade --install $(NAME) stable/prometheus-operator -n monitoring \
	--version $(VERSION-PROM-OPERATOR) \
	-f values.yaml \
	--set grafana.adminPassword=$(GRAFANA-WEB-PASSWORD) \
	--set grafana.ingress.hosts[0]=$(GRAFANA-HOST) \
	--set alertmanager.config.global.slack_api_url=$(SLACK-WEBHOOK-URL) \
	--set alertmanager.config.receivers[0].slack_configs[0].channel=$(SLACK-CHANNEL)


create-monitoring:
	kubectl create ns $(NAMESPACE)
	helm repo add stable https://kubernetes-charts.storage.googleapis.com
	helm repo update
	helm install -n $(NAMESPACE) $(NAME) stable/prometheus-operator \
	--version $(VERSION-PROM-OPERATOR) \
	-f values.yaml \
	--set grafana.adminPassword=$(GRAFANA-WEB-PASSWORD) \
	--set grafana.ingress.hosts[0]=$(GRAFANA-HOST) \
	--set alertmanager.config.global.slack_api_url=$(SLACK-WEBHOOK-URL) \
	--set alertmanager.config.receivers[0].slack_configs[0].channel=$(SLACK-CHANNEL)