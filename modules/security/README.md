# Security module

Creates shared encryption and network-security primitives:

- Purpose-specific customer-managed KMS keys
- Platform workload security group with self communication
- MSK security group allowing TLS/IAM traffic from platform workloads and
  self-referenced broker communication
- Aurora security group allowing only PostgreSQL traffic from platform workloads

Application-specific IAM roles and Kubernetes authorization remain with their
owning workloads rather than this shared module.
