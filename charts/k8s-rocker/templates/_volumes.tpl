{{- /* vim: filetype=go
Defines volumes for a podspec
*/}}
{{- define "k8s-rocker.volumes"}}
{{- $ := . }}
{{- $configmaps := dict }}
{{- $secrets := dict }}
{{- $volumes := dict }}
{{- $containers:= (deepCopy $ )}}
{{- range $name, $container := $ }}
{{- with $container.mounts }}
{{- with .configmaps }}
{{- $configmaps = (merge . $configmaps) }}
{{- end }}{{- /* end of $container.configmaps*/}}
{{- /* merge all secrets
*/}}
{{- with .secrets }}
{{- $secrets = (merge . $secrets) }}
{{- end }}{{- /* end of $container.secrets*/}}
{{- /* merge all volumes
*/}}
{{- with .volumes }}
{{- $volumes = (merge . $volumes) }}
{{- end }}{{- /* end of $container.volumes*/}}
{{- end }}{{- /* end of $container.mounts */}}
{{- end }}{{- /* end of container range
*/}}
volumes:
  {{- range $name, $configMap:= $configmaps }}
  - name: config-{{ $name }}
    configMap:
      name: {{ $name }}
  {{- end }}{{- /* end of configmaps */}}
  {{- range $name, $secret:= $secrets }}
  - name: secret-{{ $name }}
    secret:
      secretName: {{ $name }}
  {{- end }}{{- /* end of secrets */}}
  {{- range $name, $volume:= $volumes }}
  - name: pvc-{{ $name }}
    persistentVolumeClaim:
      claimName: {{ $name }}
  {{- end }}{{- /* end of volumes range */}}

{{- end }} {{/* end of define */}}
