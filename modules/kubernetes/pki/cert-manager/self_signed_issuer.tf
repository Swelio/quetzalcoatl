resource "kubernetes_manifest" "self_signed_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Issuer"
    metadata = {
      name      = "self-signed-issuer"
      namespace = "cert-manager"
      labels    = local.default_labels
    }
    spec = {
      selfSigned = {}
    }
  }

  depends_on = [terraform_data.manifest]
}
