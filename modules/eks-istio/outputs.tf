output "istio_version" { value = var.istio_version }
output "system_namespace" { value = kubernetes_namespace_v1.system.metadata[0].name }
output "ingress_namespace" { value = try(kubernetes_namespace_v1.ingress[0].metadata[0].name, null) }
output "base_release_name" { value = helm_release.base.name }
output "istiod_release_name" { value = helm_release.istiod.name }
output "ingress_release_name" { value = try(helm_release.ingress[0].name, null) }
