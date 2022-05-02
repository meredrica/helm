# Helm Charts

A collection of helm charts that I use every day and can open source.
See the docs for each chart in their respective README.md

## k8s-rocker
See the example.yaml

## yaml-rocker
### Status: ARCHIVED
A general purpose chart that works for openshift 3.
Openshift 4 is not tested (yet).
Kubernetes 4 support is planned.

### Usage
Add this to your `Chart.yaml`
```yaml
dependencies:
  - name: yaml-rocker
    version: 0.0.2
    repository: https://meredrica.github.io/helm/
```

Now use the yaml-rocker in `values.yaml`
```yaml
yaml-rocker:
  app: my-app
  name: my-name
  version: 0.0.0

  image: alpine
  tag: latest

  cpu:
    min: 100m
    max: 1000m
  memory:
    min: 500Mi
    max: 550Mi
```

You can also specify and use an alias for the file and use it multiple times.
