{{/* Check image use or set by default  */}}
{{- define "seafile.image" -}}
    {{- if .Values.seafile.configs.image }}
        {{- printf "%s" .Values.seafile.configs.image }}
    {{- else }}
        {{- printf "seafileltd/seafile-pro-mc:%s-latest" .Chart.AppVersion }}
    {{- end }}
{{- end }}

{{/* Check volume use or set by default  */}}

{{/* for storage size  */}}
{{- define "seafile.seafileDataVolume.storage" -}}
    {{- if and (.Values.seafile.configs.seafileDataVolume) (.Values.seafile.configs.seafileDataVolume.storage) }}
        {{- printf "%s" .Values.seafile.configs.seafileDataVolume.storage }}
    {{- else }}
        {{- printf "10Gi" }}
    {{- end }}
{{- end }}

{{/* for storage path  */}}
{{- define "seafile.seafileDataVolume.path" -}}
    {{- if and (.Values.seafile.configs.seafileDataVolume) (.Values.seafile.configs.seafileDataVolume.hostPath) }}
        {{- printf "%s" .Values.seafile.configs.seafileDataVolume.hostPath }}
    {{- else }}
        {{- printf "/opt/seafile-data" }}
    {{- end }}
{{- end }}