# Metrics Server module

Installs the Kubernetes Metrics Server through its official Helm repository.
It exposes the resource Metrics API used by `kubectl top` and CPU/memory-based
Horizontal Pod Autoscalers.

The module is deliberately independent of the AWS-managed EKS add-ons so it can
be installed, upgraded, rolled back, or removed without changing them.
