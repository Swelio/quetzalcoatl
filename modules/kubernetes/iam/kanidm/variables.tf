variable "namespace" {
  description = "Namespace of the resources to deploy"
  type        = string
  default     = "iam"
  nullable    = false
}

variable "kanidm_version" {
  description = "Kanidm version to deploy"
  type        = string
  default     = "latest"
  nullable    = false
}

variable "replicas" {
  description = "Number of Kanidm service replicas to deploy"
  type        = number
  default     = 1
  nullable    = false
}

variable "environment" {
  description = "Environment to deploy (such as staging, production, etc.)"
  type        = string
  nullable    = false
}

variable "domain" {
  description = "Root domain of the iam system"
  type        = string
  nullable    = false
  sensitive   = true
}
