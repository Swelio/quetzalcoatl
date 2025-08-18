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
            default_mode = "0440"
          }
        }
        volume {
          name = "kanidm-config"
          secret {
            secret_name  = kubernetes_secret.configuration.metadata[0].name
            default_mode = "0440"
          }
        }
        volume {
          name = "kanidm-db"
          empty_dir {
            size_limit = "500Mi"
          }
        }
        volume {
          name = "kanidm-admin-socket"
          empty_dir {
            size_limit = "10Mi"
          }
        }

        security_context {
          run_as_non_root = true
          run_as_user     = "1024"
          fs_group        = "1024"
        }

        container {
          name              = "server"
          image             = "docker.io/kanidm/server:${local.version}"
          image_pull_policy = "Always"

          security_context {
            allow_privilege_escalation = false
            read_only_root_filesystem  = true
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

          env {
            name  = "KANIDM_ADMIN_BIND_PATH"
            value = "/var/run/kanidm_admin.sock"
          }

          volume_mount {
            name       = "kanidm-cert"
            mount_path = "/certificate"
            read_only  = true
          }
          volume_mount {
            name       = "kanidm-config"
            mount_path = "/data"
            read_only  = true
          }
          volume_mount {
            name       = "kanidm-db"
            mount_path = "/database"
          }
          volume_mount {
            name       = "kanidm-admin-socket"
            mount_path = "/var/run"
          }
        }
      }
    }
  }

  depends_on = [kubernetes_manifest.certificate]
}
