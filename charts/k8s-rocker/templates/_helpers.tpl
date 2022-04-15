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
  name: {{$name}}
{{- $meta := $.Values.meta }}
{{- if $in.meta }}
{{- $meta = (deepCopy $.Values.meta | merge $in.meta )}}
{{- end }}
  labels:
    app: {{ include "k8s-rocker.name" $ }}
    {{- range $key, $value := $meta.labels }}
    {{ $key }}: {{ $value }}
    {{- end }} {{/* end of labels */}}
  annotations:
    {{- range $key, $value := $meta.annotations }}
    {{ $key }}: {{ $value }}
    {{- end }} {{/* end of annotations*/}}
{{- end }}  {{/* end of k8s-rocker.object }}


{{/*
Expand the name of the chart.
*/}}
{{- define "k8s-rocker.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "k8s-rocker.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "k8s-rocker.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "k8s-rocker.labels" -}}
helm.sh/chart: {{ include "k8s-rocker.chart" . }}
{{ include "k8s-rocker.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "k8s-rocker.selectorLabels" -}}
app.kubernetes.io/name: {{ include "k8s-rocker.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "k8s-rocker.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "k8s-rocker.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
