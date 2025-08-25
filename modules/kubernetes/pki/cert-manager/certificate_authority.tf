resource "kubernetes_manifest" "certificate_authority" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name   = "certificate-authority"
      labels = local.default_labels
    }
    spec = {
      ca = {
        secretName = var.authority_certificate_secret_name
      }
    }
  }
}
