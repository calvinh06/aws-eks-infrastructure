# EKS Istio module

Installs a pinned Istio control plane and optional ingress gateway from the official Helm charts. Application namespaces, injection labels, routing, mTLS and authorization policies remain application-owned.

The ingress gateway defaults to `ClusterIP` to avoid a paid AWS load balancer in the lab. Set `gateway_service_type = "LoadBalancer"` only when external ingress is required.
