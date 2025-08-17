locals {
  version                      = var.cert_manager_version
  static_manifest_url          = "https://github.com/cert-manager/cert-manager/releases/download/v${local.version}/cert-manager.yaml"
  certificate_authority_secret = "authority-secret"

  default_labels = {
    part-of    = "pki"
    managed-by = "Terraform"
  }
}

resource "terraform_data" "manifest" {
  input = local.static_manifest_url

  provisioner "local-exec" {
    when    = create
    command = "kubectl apply -f ${self.input}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete -f ${self.input}"
  }
}
