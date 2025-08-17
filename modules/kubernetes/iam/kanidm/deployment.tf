resource "kubernetes_deployment" "this" {
  metadata {
    name      = local.default_labels.app
    namespace = local.namespace
    labels    = local.default_labels
  }

  timeouts {
    create = "1m"
    update = "1m"
    delete = "1m"
  }

  spec {
    replicas               = local.replicas
    revision_history_limit = 2

    selector {
      match_labels = local.default_labels
    }

    template {
      metadata {
        name      = local.default_labels.app
        namespace = local.namespace
        labels    = local.default_labels
      }

      spec {
        volume {
          name = "kanidm-cert"
          secret {
            secret_name  = "kanidm-certificate"
            default_mode = "0400"
          }
        }

        container {
          name              = "server"
          image             = "docker.io/kanidm/server:${local.version}"
          image_pull_policy = "Always"

          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = ["ALL"]
            }
          }

          resources {
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }

            limits = {
              cpu    = "1"
              memory = "1536Mi"
            }
          }

          liveness_probe {
            initial_delay_seconds = 30
            period_seconds        = 5

            http_get {
              path   = "/status"
              port   = "https"
              scheme = "HTTPS"
            }
          }

          volume_mount {
            name       = "kanidm-cert"
            mount_path = "/certificate"
            read_only  = true
          }

          env {
            name  = "KANIDM_DOMAIN"
            value = "kanidm.iam.svc.cluster.local"
          }
          env {
            name  = "KANIDM_DB_PATH"
            value = "/data/kanidm.db"
          }
          env {
            name  = "KANIDM_ORIGIN"
            value = "https://kanidm.iam.svc.cluster.local"
          }

          env {
            name  = "KANIDM_TLS_CHAIN"
            value = "/certificate/tls.crt"
          }

          env {
            name  = "KANIDM_TLS_KEY"
            value = "/certificate/tls.key"
          }
        }
      }
    }
  }

  depends_on = [kubernetes_manifest.certificate]
}
