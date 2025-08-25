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
      commonName = local.domain
      secretName = "kanidm-certificate"
      privateKey = {
        algorithm = "ECDSA"
        size      = 384
      }
      issuerRef = {
        name  = "certificate-authority"
        kind  = "ClusterIssuer"
        group = "cert-manager.io"
      }
      usages = [
        "digital signature",
        "server auth"
      ]
      dnsNames = [
        local.domain
      ]
    }
  }
}
