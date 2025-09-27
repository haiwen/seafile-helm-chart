{{/* Check image use or set by default  */}}
{{- define "seafile.image" -}}
    {{- if .Values.seafile.configs.image }}
        {{- printf "%s" .Values.seafile.configs.image }}
    {{- else }}
        {{- printf "seafileltd/seafile-pro-mc:%s-latest" .Chart.AppVersion }}
    {{- end }}
{{- end }}

{{/* Check volume use or set by default  */}}

{{- define "seafile.seafileDataVolume.enabled" -}}
    {{- $config := .Values.seafile.configs.seafileDataVolume -}}
    {{- if or 
        (not $config) 
        (eq ($config.disablePVC | default false) false)
    }}
        {{- printf "true" }}
    {{- else }}
        {{- printf "false" }}
    {{- end }}
{{- end }}

{{/* for storage size  */}}
{{- define "seafile.seafileDataVolume.storage" -}}
    {{- if and (.Values.seafile.configs.seafileDataVolume) (.Values.seafile.configs.seafileDataVolume.storage) }}
        {{- printf "%s" .Values.seafile.configs.seafileDataVolume.storage }}
    {{- else }}
        {{- printf "10Gi" }}
    {{- end }}
{{- end }}

{{/* check initMode use and set by default, and check init vars  */}}
{{- define "seafile.cluster.frontendNums" -}}
    {{- if .Values.seafile.initMode }}
        {{- printf "0" -}}
    {{- else if .Values.seafile.configs.seafileFrontendReplicas }}
        {{- printf "%s" .Values.seafile.configs.seafileFrontendReplicas }}
    {{- else }}
        {{- printf "2" }}
    {{- end }}
{{- end }}
