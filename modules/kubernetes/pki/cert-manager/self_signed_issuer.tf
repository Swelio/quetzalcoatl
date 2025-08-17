resource "kubernetes_manifest" "self_signed_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name   = "self-signed-issuer"
      labels = local.default_labels
    }
    spec = {
      selfSigned = {}
    }
  }

  depends_on = [terraform_data.manifest]
}
