output "release_name" {
  value = module.metrics_server.release_name
}

output "namespace" {
  value = module.metrics_server.namespace
}

output "chart_version" {
  value = module.metrics_server.chart_version
}

output "status" {
  value = module.metrics_server.status
}
