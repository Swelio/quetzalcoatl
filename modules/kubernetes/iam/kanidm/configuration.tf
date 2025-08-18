resource "kubernetes_secret" "configuration" {
  metadata {
    name      = "kanidm-configuration"
    namespace = local.namespace
    labels    = local.default_labels
  }

  data = {
    "server.toml" = templatefile("${path.module}/configuration.toml.tftpl", { domain = local.domain })
  }
}
