# k8s Rocker
A general purpose kubernetes chart.
The chart takes an oppinionated approach and is geared towards running microservices.

This is more or less the second evolution of the yaml rocker.
It's kubernetes native only (no openshift dependencies)

## Features
- Every top level block is optional.
  This means you can use the chart to simply deploy a couple of config maps or a full fledged app with multiple containers.
- Init and test containers.
- Specify metadata for all objects at once and individually.
- Templates formatted as much as possible to be readable.

## Supported kubernetes objects:
- [Persistent Volume Claims](https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/persistent-volume-claim-v1/)
- [Config Maps](https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/config-map-v1/)
- [Secrets](https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/secret-v1/)
- [Ingress](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/ingress-v1/)
- [Service](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/)
- [Deployments](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/deployment-v1/) with optional [Horizontal Pod Autoscaling](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/horizontal-pod-autoscaler-v2/) `v2`.
- [Stateful Sets](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/stateful-set-v1/)
- [CronJobs](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/cron-job-v1/)

# How To
See the [example](example.yaml) file.

# Versions
Patch versions are always downward compatible.
Minors remove deprecated values etc.
Majors (usually) require you to rewrite everyhting.
