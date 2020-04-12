install:
	kubectl apply -f monitoring/namespace.yaml
	helm install stable/prometheus --name-template prometheus --namespace monitoring --values monitoring/prometheus/values.yaml
	kubectl apply -f monitoring/grafana/config.yaml
	helm install stable/grafana --name-template grafana --namespace monitoring --values monitoring/grafana/values.yaml

install-local:
	kubectl apply -f monitoring/namespace.yaml
	helm install stable/prometheus --name-template prometheus --namespace monitoring --values monitoring/prometheus/values.yaml --values monitoring/prometheus/values-local.yaml
	kubectl apply -f monitoring/grafana/config.yaml
	helm install stable/grafana --name-template grafana --namespace monitoring --values monitoring/grafana/values.yaml -f monitoring/grafana/values-values.yaml 

upgrade:
	helm upgrade --install stable/prometheus --name-template prometheus --namespace monitoring --values monitoring/prometheus/values.yaml
	helm upgrade --install stable/grafana --name-template grafana --namespace monitoring --values monitoring/grafana/values.yaml

upgrade-local:
	helm upgrade --install stable/prometheus --name-template prometheus --namespace monitoring --values monitoring/prometheus/values.yaml --values monitoring/prometheus/values-local.yaml
	helm upgrade --install stable/grafana --name-template grafana --namespace monitoring --values monitoring/grafana/values.yaml -f monitoring/grafana/values-values.yaml 

uninstall:
	helm uninstall prometheus --namesapce monitoring
	helm uninstall grafana --namesapce monitoring

dry-run:
	helm upgrade --install --dry-run stable/prometheus --name-template prometheus --namespace monitoring --values monitoring/prometheus/values.yaml
	helm upgrade --install --dry-run stable/grafana --name-template grafana --namespace monitoring --values monitoring/grafana/values.yaml