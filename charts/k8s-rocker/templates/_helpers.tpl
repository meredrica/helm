{{- /* vim: filetype=go
Define a top level object
*/}}
{{- define "k8s-rocker.object" }}
{{- $ := index . 0 }}
{{- $api:= index . 1 }}
{{- $kind:= index . 2 }}
{{- $name:= index . 3 | trunc 63 | trimSuffix "-"}}
{{- $in:= index . 4 }}
apiVersion: {{ $api }}
kind: {{ $kind }}
{{- include "k8s-rocker.meta" (list $ $name $in.meta) }}
{{- end }}{{- /* end of k8s-rocker.object */}}
{{- /*

Selector labels
*/}}
{{- define "k8s-rocker.matchLabels" }}
{{- $ := . }}
"app.kubernetes.io/name": "{{ include "k8s-rocker.name" $ }}"
"app.kubernetes.io/instance": {{ $.Release.Name | quote}}
{{- end }}
{{- /*

Expand the name of the chart.
*/}}
{{- define "k8s-rocker.name" }}
{{- default .Chart.Name $.Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- /*

Meta annotations
*/}}
{{- define "k8s-rocker.meta" }}
{{- $ := index . 0 }}
{{- $name:= index . 1 }}
{{- $in:= index . 2 }}
{{- $meta:= dict }}
{{- if $.Values.meta }}
{{- $meta := $.Values.meta }}
{{- end}}
{{- if $in }}
{{- $meta = (deepCopy $meta | merge $in )}}
{{- end }}
metadata:
  {{- with $name }}
  name: {{ . }}
  {{- end }}
  labels: {{- include "k8s-rocker.matchLabels" $ | indent 4 }}
    "app.kubernetes.io/version": {{ default $.Chart.Version $.Values.version | quote}}
    {{- range $key, $value := $meta.labels }}
    {{ $key | quote }}: {{ $value | quote }}
    {{- end }} {{- /* end of labels*/}}
  annotations:
    {{- range $key, $value := $meta.annotations }}
    {{ $key | quote }}: {{ $value | quote }}
    {{- end }}{{- /* end of annotations*/}}
{{- end }}{{- /* end of k8s-rocker.meta*/}}
