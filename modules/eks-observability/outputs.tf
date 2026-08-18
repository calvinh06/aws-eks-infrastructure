output "namespace" { value = helm_release.kube_prometheus_stack.namespace }
output "release_name" { value = helm_release.kube_prometheus_stack.name }
output "chart_version" { value = helm_release.kube_prometheus_stack.version }

