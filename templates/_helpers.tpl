{{- define "fullname" }}
{{- printf "%s-%s" .Release.Name .Values.name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "safename" }}
{{- regexReplaceAll "[^a-zA-Z]" . "" }}
{{- end }}

# prints an annotation block with key-value pairs, or nothing if none are present
# best used like this: {{/*
{{- include "annotations" <scope> | indent <indentation> }}
*/}}
{{- define "annotations" }}
{{- if . }}
annotations:
{{- range $key, $val:= . }}
  {{ $key }}: {{ $val | quote }}
{{- end }}
{{- end }}
{{- end }}

