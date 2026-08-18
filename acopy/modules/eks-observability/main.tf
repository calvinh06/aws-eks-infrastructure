resource "helm_release" "kube_prometheus_stack" {
  name             = var.release_name
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = var.chart_version
  atomic           = true
  cleanup_on_fail  = true
  timeout          = var.helm_timeout_seconds
  wait             = true

  values = [yamlencode({
    prometheus = {
      prometheusSpec = {
        retention = var.prometheus_retention
        storageSpec = var.prometheus_storage_enabled ? {
          volumeClaimTemplate = {
            spec = {
              storageClassName = var.storage_class_name
              accessModes      = ["ReadWriteOnce"]
              resources = { requests = { storage = var.prometheus_storage_size } }
            }
          }
        } : {}
      }
    }
    grafana = {
      enabled = true
      persistence = {
        enabled          = var.grafana_storage_enabled
        storageClassName = var.storage_class_name
        size             = var.grafana_storage_size
      }
      service = { type = "ClusterIP" }
    }
    alertmanager = { enabled = true }
  })]
}

