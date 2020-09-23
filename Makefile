
#helm installation name
NAME = monitoring
#namespace to install monitoring
NAMESPACE = monitoring
#version prometheus-operator helm chart
VERSION-PROM-OPERATOR = 9.4.4
#grafana external hostname
GRAFANA-HOST = "example.local"
#admin user password in grafana
GRAFANA-WEB-PASSWORD = "CHANGEME"
SLACK-WEBHOOK-URL = "https://hooks.slack.com/"CHANGEME""
#notification channel name in slack. do not delete "\". it screens "#"
SLACK-CHANNEL = "\#CHANGEME"

.PHONY:
upgrade-monitoring:
	helm upgrade --install -n $(NAMESPACE) $(NAME) prometheus-community/kube-prometheus-stack \
	-f values.yaml \
	--set prometheusOperator.createCustomResource=false \
	--set grafana.adminPassword=$(GRAFANA-WEB-PASSWORD) \
	--set grafana.ingress.hosts[0]=$(GRAFANA-HOST) \
	--set alertmanager.config.global.slack_api_url=$(SLACK-WEBHOOK-URL) \
	--set alertmanager.config.receivers[0].slack_configs[0].channel=$(SLACK-CHANNEL) \
	--version $(VERSION-PROM-OPERATOR) \

create-monitoring:
#	kubectl create ns $(NAMESPACE)
	helm repo add stable https://kubernetes-charts.storage.googleapis.com
	helm repo update
	helm upgrade --install -n $(NAMESPACE) $(NAME) prometheus-community/kube-prometheus-stack \
	-f values.yaml \
	--set grafana.adminPassword=$(GRAFANA-WEB-PASSWORD) \
	--set grafana.ingress.hosts[0]=$(GRAFANA-HOST) \
	--set alertmanager.config.global.slack_api_url=$(SLACK-WEBHOOK-URL) \
	--set alertmanager.config.receivers[0].slack_configs[0].channel=$(SLACK-CHANNEL) \
	--version $(VERSION-PROM-OPERATOR)