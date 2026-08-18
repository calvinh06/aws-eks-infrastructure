# EKS KEDA module

Installs KEDA core and its CRDs as a standalone platform component. The module
does not own application ScaledObject, ScaledJob, TriggerAuthentication, or
ClusterTriggerAuthentication resources. Those belong with application
deployments. Istio sidecar injection is disabled for the KEDA namespace.

