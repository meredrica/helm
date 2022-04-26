{{- define "k8s-rocker.container" }}
{{- /*
containers:
  'name':
    image:
    tag:
    policy: 'IfNotPresent'
    memory:
      min: 100Mi
      max: 110Mi
    command: # startup command
    args: # startup args
    ports:
      'name':
        port:
        target:
        protocol: 'TCP'
    env:
      'name': # if raw is specified, mount valuefrom etc
        raw: {}
    health: # healthchecks
    mounts: # mounts
      volumes:
        'name':
          path:
      secrets:
      env: # TODO
      configmaps:
    affinity: # passed raw into the affinity block
*/}}
{{- $ := index . 0 }}
{{- $name:= index . 1 }}
{{- $container:= index . 2 }}
name: {{ $name }}
image: {{ required "container.image is required" $container.image }}:{{ required "container.tag is required" $container.tag }}
imagePullPolicy: {{ default "IfNotPresent" $container.policy }}
{{- /*

---- command and args
*/}}
{{- with $container.command }}
command:
  {{- range . }}
  - {{ . | quote }}
  {{- end }}
{{- end }}
{{- with $container.args }}
args:
  {{- range . }}
  - {{ . | quote }}
  {{- end }}
{{- end }}
{{- /*

---- ports
*/}}
{{- with $container.ports }}
ports:
{{- range $name, $port := . }}
  - name: {{ $name }}
    containerPort: {{ required "port.port is required" $port.port }}
    protocol: {{ default "TCP" $port.protocol }}
  {{- end }}
{{- end }}
{{- /*

---- env
*/}}
{{- with $container.env }}
env:
  {{- range $name, $env := . }}
  {{- if (kindIs "map" $env ) }}
  - name: {{ $name}}{{ $env | toYaml | nindent 4}}
  {{- else }}
  - name: {{ $name}}
    value: {{ required "env value is required" $env }}
  {{- end }} {{/* end of kindIs */}}
  {{- end }}
{{- end }}
{{- /*

---- probes
*/}}
{{- with $container.health }}
{{- with .live }}
livenessProbe: {{ . | toYaml | nindent 2 }}
{{- end }}
{{- with .ready }}
readinessProbe: {{ . | toYaml | nindent 2 }}
{{- end }}
{{- with .start }}
startupProbe: {{ . | toYaml | nindent 2 }}
{{- end }}
{{- end }}{{/* end of $container.health */}}
{{- /*

---- resources
*/}}
{{- if or $container.cpu $container.memory}}
resources:
  limits:
  {{- with $container.cpu }}
    cpu: {{ .max }}
  {{- end }}
  {{- with $container.memory }}
    memory: {{ .max }}
  {{- end }}
  requests:
  {{- with $container.memory }}
    memory: {{ .max}}
  {{- end }}
  {{- with $container.cpu }}
    cpu: {{ .min}}
  {{- end }}
{{- end }} {{/* end of $container.cpu || $container.memory*/}}
{{- /*

---- raw block
*/}}
{{- with $container.raw }}
{{ . | toYaml | nindent 2 }}
{{- end }}
{{- /*

TODO: mounts, affinity
*/}}
{{- end }}{{/* end of k8s-rocker.container */}}
