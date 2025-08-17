resource "kubernetes_manifest" "certificate" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      name      = "kanidm-certificate"
      namespace = local.namespace
      labels    = local.default_labels
    }
    spec = {
      isCA       = false
      commonName = "kanidm"
      secretName = "kanidm-certificate"
      privateKey = {
        algorithm = "Ed25519"
      }
      issuerRef = {
        name  = "certificate-authority"
        kind  = "ClusterIssuer"
        group = "cert-manager.io"
      }
      usages = [
        "server auth"
      ]
    }
  }
}
