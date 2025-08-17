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
        secretName = local.certificate_authority_secret
      }
    }
  }

  depends_on = [kubernetes_manifest.certificate_authority_certificate]
}
