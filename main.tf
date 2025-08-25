terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.1.0"
    }
  }
}

provider "kubernetes" {
  config_path = ".kubeconfig"
}

provider "tls" {}

locals {
  domain                            = "dev.quetzalcoatl.localhost"
  environment                       = "development"
  authority_certificate_secret_name = "quetzalcoatl-authority"

  default_labels = {
    managed-by  = "Terraform"
    environment = local.environment
  }
}

module "pki" {
  source                            = "./modules/kubernetes/pki/cert-manager"
  authority_certificate_secret_name = local.authority_certificate_secret_name

  depends_on = [kubernetes_secret.certificate_authority]
}

module "iam" {
  source = "./modules/kubernetes/iam/kanidm"

  domain         = local.domain
  environment    = local.environment
  kanidm_version = null
  namespace      = kubernetes_namespace.iam.metadata[0].name
  replicas       = 1

  depends_on = [kubernetes_namespace.iam, module.pki]
}

resource "kubernetes_namespace" "iam" {
  metadata {
    name   = "iam"
    labels = local.default_labels
  }
}

resource "kubernetes_secret" "certificate_authority" {
  metadata {
    name      = local.authority_certificate_secret_name
    namespace = "cert-manager"
    labels    = local.default_labels
  }

  data = {
    "tls.crt" = tls_self_signed_cert.certificate_authority.cert_pem
    "tls.key" = tls_private_key.certificate_authority.private_key_pem
  }
}

resource "tls_private_key" "certificate_authority" {
  algorithm = "ED25519"
}

resource "tls_self_signed_cert" "certificate_authority" {
  private_key_pem   = tls_private_key.certificate_authority.private_key_pem
  is_ca_certificate = true

  subject {
    common_name  = local.domain
    organization = "Quetzalcoatl Example"
  }

  validity_period_hours = 8

  allowed_uses = [
    "cert_signing",
    "crl_signing",
    "digital_signature",
  ]

  dns_names = [local.domain]
}
