terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
    }
  }
}

provider "kubernetes" {
  config_path = ".kubeconfig"
}

locals {
  environment = "development"

  default_labels = {
    managed-by  = "Terraform"
    environment = local.environment
  }
}

module "cert-manager" {
  source               = "./modules/kubernetes/pki/cert-manager"
  cert_manager_version = "1.18.2"
}

resource "kubernetes_namespace" "iam" {
  metadata {
    name   = "iam"
    labels = local.default_labels
  }
}

module "iam" {
  source = "./modules/kubernetes/iam/kanidm"

  environment    = local.environment
  kanidm_version = null
  namespace      = kubernetes_namespace.iam.metadata[0].name
  replicas       = 1

  depends_on = [kubernetes_namespace.iam, module.cert-manager]
}
