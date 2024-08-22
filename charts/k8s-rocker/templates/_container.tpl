{{- /* vim: filetype=go
Define a container that can be reused
*/}}
{{- define "k8s-rocker.container" }}
{{- /*
'name':
  image: nginx
  tag: latest
  policy: 'IfNotPresent' # imagePullPolicy
  cpu:
    min: 100m
    max: 200m
  memory:
    min: 100Mi
    max: 110Mi

  command: # startup command
    - echo
  args: # startup args
    - $NAME
    - $raw-from
  ports:
    'port-name':
      port: 80
      protocol: 'TCP'
  env:
    'NAME': 'SOME_ENV_VALUE'
    'raw-from': # passed raw
      valueFrom:
        fieldRef:
          fieldPath: metadata.name
  health:
    live: # a probe spec, passed raw
      httpGet:
        port: 80
        path: '/'
    ready: # a probe spec, passed raw. defaults to live
      httpGet:
        port: 80
        path: '/ready'
    start: # a probe spec, passed raw. defaults to live
      httpGet:
        port: 80
        path: '/start'
  restart: 'Always' # restartPolicy
  mounts: # mounts
    volumes:
      'volumename':
        path: '/some/path'
        readOnly: true
        subPath: '.something'
    secrets:
      'secretname': '/secret/path'
    configmaps:
      'configmapname': '/configmap/path'
      'complexMap':
        path: '/some/path'
        subPath: '.something'
  raw: # passed raw into the container spec
*/}}
{{- $ := index . 0 }}
{{- $name:= index . 1 }}
{{- $container:= index . 2 }}
name: {{ $name }}
image: {{ required "container.image is required" $container.image }}:{{ default "latest" $container.tag }}
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
    value: {{ required "env value is required" $env | quote }}
  {{- end }}{{- /* end of kindIs */}}
  {{- end }}
{{- end }}
{{- /*

---- probes
*/}}
{{- with $container.health }}
{{- with .live }}
livenessProbe: {{ . | toYaml | nindent 2 }}
{{- end }}
{{- if .ready }}
readinessProbe: {{ .ready | toYaml | nindent 2 }}
{{- else if .live }}
readinessProbe: {{ .live | toYaml | nindent 2 }}
{{- end }}
{{- if .start }}
startupProbe: {{ .start | toYaml | nindent 2 }}
{{- else if .live }}
startupProbe: {{ .live | toYaml | nindent 2 }}
{{- end }}
{{- end }}{{- /* end of $container.health */}}
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
    memory: {{ .min }}
  {{- end }}
  {{- with $container.cpu }}
    cpu: {{ .min }}
  {{- end }}
{{- end }}{{- /* end of $container.cpu || $container.memory */}}

{{- /*

---- mounts
*/}}
{{- with $container.mounts }}
volumeMounts:
{{- with .configmaps }}
{{- range $name, $configmap:= . }}
  - name: config-{{ $name }}
    {{- if (kindIs "string" $configmap) }}
    mountPath: {{ $configmap}}
    {{- else }}
    mountPath: {{ required "configmap.path is required" $configmap.path }}
    {{- with $configmap.subPath }}
    subPath: {{ . }}
    {{- end }}
    {{- end }}
{{- end }}{{- /* end of configmap range */}}
{{- end }}{{- /* end of configmaps

*/}}
{{- with .secrets }}
{{- range $name, $path:= . }}
  - name: secret-{{ $name }}
    mountPath: {{ $path }}
{{- end }}{{- /* end of secrets range */}}
{{- end }}{{- /* end of secrets

*/}}
{{- with .volumes }}
{{- range $name, $volume:= .}}
  - name: pvc-{{ $name }}
    {{- if (kindIs "string" $volume ) }}
    mountPath: {{ $volume }}
    {{- else }}
    mountPath: {{ required "volume.path is required" $volume.path }}
    {{- with $volume.readOnly }}
    readOnly: {{ . }}
    {{- end }}
    {{- with $volume.subPath }}
    subPath: {{ . }}
    {{- end }}
    {{- end }}
{{- end }}{{- /* end of volumes range */}}
{{- end }}{{- /* end of volumeMounts */}}
{{- end }}{{- /* end of $container.mounts */}}
{{- /*

---- raw block
*/}}
{{- with $container.raw }}
{{ . | toYaml | nindent 2 }}
{{- end }}{{- /* end of raw */}}
{{- end }}{{- /* end of k8s-rocker.container */}}
