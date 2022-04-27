{{/*
Define a top level object
*/}}
{{- define "k8s-rocker.object" }}
{{- $ := index . 0 }}
{{- $api:= index . 1 }}
{{- $kind:= index . 2 }}
{{- $name:= index . 3 }}
{{- $in:= index . 4 }}
apiVersion: {{ $api }}
kind: {{$kind}}
metadata:
  name: {{ $name | trunc 63 | trimSuffix "-" }}
{{- $meta:= dict }}
{{- if $.Values.meta }}
{{- $meta := $.Values.meta }}
{{- end}}
{{- if $in.meta }}
{{- $meta = (deepCopy $meta | merge $in.meta )}}
{{- end }}
  labels:
    {{- include "k8s-rocker.matchLabels" $ | indent 4 }}
    {{- range $key, $value := $meta.labels }}
    {{ $key | quote }}: {{ $value | quote }}
    {{- end }} {{/* end of labels*/}}
  annotations:
    {{- range $key, $value := $meta.annotations }}
    {{ $key | quote }}: {{ $value | quote }}
    {{- end }} {{/* end of annotations*/}}
{{- end }}  {{/* end of k8s-rocker.object }}

{{/*
Selector labels
*/}}
{{- define "k8s-rocker.matchLabels" -}}
{{- $ := .  }}
app.kubernetes.io/name: {{ include "k8s-rocker.name" $ }}
app.kubernetes.io/instance: {{ $.Release.Name }}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "k8s-rocker.name" -}}
{{- default .Chart.Name $.Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
