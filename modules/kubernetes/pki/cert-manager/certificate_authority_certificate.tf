resource "kubernetes_manifest" "certificate_authority_certificate" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      name      = "certificate-authority"
      namespace = "cert-manager"
      labels    = local.default_labels
    }
    spec = {
      isCA       = true
      commonName = "cluster-ca"
      secretName = local.certificate_authority_secret
      privateKey = {
        algorithm = "Ed25519"
      }
      issuerRef = {
        name  = "self-signed-issuer"
        kind  = "ClusterIssuer"
        group = "cert-manager.io"
      }
    }
  }

  depends_on = [kubernetes_manifest.self_signed_issuer]
}
