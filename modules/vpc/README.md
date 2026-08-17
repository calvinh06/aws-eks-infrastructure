# VPC module

Creates the network foundation used by the transaction-exchange platform:

- Public ingress subnets
- Private EKS subnets
- Isolated private data subnets
- Internet gateway and public routes
- Configurable single or per-AZ NAT gateways
- Optional S3 gateway endpoint
- Kubernetes load-balancer discovery tags

The module requires at least two Availability Zones because Amazon EKS requires
cluster subnets in at least two different zones.
