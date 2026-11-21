{{/* Check image use or set by default  */}}
{{- define "seafile.image" -}}
    {{- if .Values.seafile.configs.image -}}
        {{- printf "%s" .Values.seafile.configs.image }}
    {{- else -}}
        {{- printf "seafileltd/seafile-pro-mc:%s-latest" .Chart.AppVersion }}
    {{- end }}
{{- end }}

{{/* Mount the existing claim, or fall back to the built-in claim when enabled. */}}
{{- define "seafile.seafileDataVolume.claimName" -}}
    {{- $config := .Values.seafile.configs.seafileDataVolume | default dict -}}
    {{- if $config.existingClaim -}}
        {{- $config.existingClaim -}}
    {{- else if eq (include "seafile.seafileDataVolume.managed" .) "true" -}}
        {{- print "seafile-data" -}}
    {{- end -}}
{{- end -}}

{{/* Create and initialize the built-in PVC only when no existing claim is set. */}}
{{- define "seafile.seafileDataVolume.managed" -}}
    {{- $config := .Values.seafile.configs.seafileDataVolume | default dict -}}
    {{- and (not $config.existingClaim) (not ($config.disablePVC | default false)) -}}
{{- end }}

{{/* for storage size  */}}
{{- define "seafile.seafileDataVolume.storage" -}}
    {{- if and (.Values.seafile.configs.seafileDataVolume) (.Values.seafile.configs.seafileDataVolume.storage) -}}
        {{- printf "%s" .Values.seafile.configs.seafileDataVolume.storage }}
    {{- else -}}
        {{- printf "10Gi" }}
    {{- end }}
{{- end }}

{{/* check initMode use and set by default, and check init vars  */}}
{{- define "seafile.cluster.frontendNums" -}}
    {{- if .Values.seafile.initMode -}}
        {{- printf "0" -}}
    {{- else if .Values.seafile.configs.seafileFrontendReplicas -}}
        {{- printf "%s" .Values.seafile.configs.seafileFrontendReplicas }}
    {{- else -}}
        {{- printf "2" }}
    {{- end }}
{{- end }}
