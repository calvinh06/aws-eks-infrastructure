# EKS cluster module

Creates an EKS cluster, cluster and node IAM roles, one managed node group, a
restricted public/private API endpoint, control-plane logs, secrets encryption,
and an explicit administrator access entry.

The node role temporarily carries `AmazonEKS_CNI_Policy` so the default VPC CNI
can initialize. Move that permission to the VPC CNI add-on identity when the
add-ons target is deployed.
