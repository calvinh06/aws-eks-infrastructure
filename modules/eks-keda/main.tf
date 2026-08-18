locals {
  namespace_labels = merge({
    "app.kubernetes.io/managed-by" = "terraform"
    "istio-injection"              = "disabled"
  }, var.tags)
}

resource "kubernetes_namespace_v1" "this" {
  metadata {
    name   = var.namespace
    labels = local.namespace_labels
  }
}

resource "helm_release" "this" {
  name            = "keda"
  repository      = "https://kedacore.github.io/charts"
  chart           = "keda"
  version         = var.keda_version
  namespace       = kubernetes_namespace_v1.this.metadata[0].name
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  wait_for_jobs   = true
  timeout         = 600
}

