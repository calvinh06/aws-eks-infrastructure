# Karpenter module

Installs Karpenter and the AWS resources it requires:

- controller role using EKS Pod Identity
- node role, instance profile, and EKS access entry
- interruption SQS queue and EventBridge rules
- subnet discovery tags and explicit node security-group selection
- official Karpenter OCI Helm chart
- lab-scoped `EC2NodeClass` and `NodePool`

The managed EKS node group remains the stable home for the Karpenter controller.
Karpenter nodes are intended for application workloads.
