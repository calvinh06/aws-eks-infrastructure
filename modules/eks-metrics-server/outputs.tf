output "release_name" {
  value = helm_release.this.name
}

output "namespace" {
  value = helm_release.this.namespace
}

output "chart_version" {
  value = helm_release.this.version
}

output "status" {
  value = helm_release.this.status
}
