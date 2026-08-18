resource "helm_release" "this" {
  name       = var.release_name
  namespace  = var.namespace
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = var.chart_version

  atomic          = true
  cleanup_on_fail = true
  timeout         = var.timeout_seconds
  wait            = true

  values = [
    yamlencode({
      replicas = var.replicas

      podDisruptionBudget = {
        enabled      = var.replicas > 1
        minAvailable = 1
      }

      resources = {
        requests = {
          cpu    = var.resources.requests.cpu
          memory = var.resources.requests.memory
        }
        limits = {
          cpu    = var.resources.limits.cpu
          memory = var.resources.limits.memory
        }
      }

      args = var.extra_args
    })
  ]
}
