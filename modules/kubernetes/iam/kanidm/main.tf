locals {
  domain    = "kanidm.iam"
  namespace = var.namespace
  version   = var.kanidm_version
  replicas  = var.replicas
  default_labels = {
    app         = "kanidm"
    part-of     = "iam"
    managed-by  = "Terraform"
    environment = var.environment
  }
}
