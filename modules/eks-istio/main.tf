locals {
  namespace_labels = merge({
    "app.kubernetes.io/managed-by" = "terraform"
  }, var.tags)
}

resource "kubernetes_namespace_v1" "system" {
  metadata {
    name   = var.system_namespace
    labels = local.namespace_labels
  }
}

resource "kubernetes_namespace_v1" "ingress" {
  count = var.install_ingress_gateway ? 1 : 0
  metadata {
    name = var.ingress_namespace
    labels = merge(local.namespace_labels, {
      "istio-injection" = "enabled"
    })
  }
}

resource "helm_release" "base" {
  name            = "istio-base"
  repository      = "https://istio-release.storage.googleapis.com/charts"
  chart           = "base"
  version         = var.istio_version
  namespace       = kubernetes_namespace_v1.system.metadata[0].name
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 600
  set             = [{ name = "defaultRevision", value = "default" }]
}

resource "helm_release" "istiod" {
  name            = "istiod"
  repository      = "https://istio-release.storage.googleapis.com/charts"
  chart           = "istiod"
  version         = var.istio_version
  namespace       = kubernetes_namespace_v1.system.metadata[0].name
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 600
  values = [yamlencode({
    pilot = {
      autoscaleEnabled = false
      replicaCount     = 1
      resources        = var.pilot_resources
    }
    global = {
      defaultResources = { requests = { cpu = "10m" } }
    }
  })]
  depends_on = [helm_release.base]
}

resource "helm_release" "ingress" {
  count           = var.install_ingress_gateway ? 1 : 0
  name            = "istio-ingress"
  repository      = "https://istio-release.storage.googleapis.com/charts"
  chart           = "gateway"
  version         = var.istio_version
  namespace       = kubernetes_namespace_v1.ingress[0].metadata[0].name
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 600
  values = [yamlencode({
    replicaCount = 1
    service      = { type = var.gateway_service_type }
    resources    = var.gateway_resources
  })]
  depends_on = [helm_release.istiod]
}
