{{/*
Expand the name of the chart.
*/}}
{{- define "strapi.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "strapi.fullname" -}}
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
{{- define "strapi.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "strapi.internalDatabaseUrl" -}}
{{- printf "%s%s%s%s%s%s%s%s" "postgresql://" .Values.postgresql.auth.username ":" .Values.postgresql.auth.password "@" .Release.Name "-postgresql:5432/" .Values.postgresql.auth.database }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "strapi.labels" -}}
helm.sh/chart: {{ include "strapi.chart" . }}
{{ include "strapi.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "strapi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "strapi.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{- define "strapi.ingressAnnotations" -}}
nginx.ingress.kubernetes.io/cors-allow-credentials: "true"
nginx.ingress.kubernetes.io/cors-allow-methods: "PUT, GET, POST, OPTIONS, DELETE"
{{- if .Values.dashboardDomain }}
nginx.ingress.kubernetess.io/cors-allow-origin: {{ printf "%s%s" "https://" .Values.dashboardDomain }}
nginx.ingress.kubernetes.io/enable-cors: "true"
{{- end }}
{{- if .Values.ingress.annotations }}
{{ toYaml .Values.ingress.annotations }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "strapi.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "strapi.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
