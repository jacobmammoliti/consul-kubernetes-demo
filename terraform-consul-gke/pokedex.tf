resource "kubernetes_namespace" "pokedex" {
  metadata {
    name = "pokedex"
  }

  depends_on = [helm_release.consul]
}

resource "kubernetes_service_account" "pokedex" {
  metadata {
    name      = "pokedex"
    namespace = kubernetes_namespace.pokedex.metadata[0].name
  }
}

resource "kubernetes_service_account" "static-client" {
  metadata {
    name      = "static-client"
    namespace = kubernetes_namespace.pokedex.metadata[0].name
  }
}

resource "kubernetes_deployment" "pokedex" {
  metadata {
    name      = "pokedex"
    namespace = kubernetes_namespace.pokedex.metadata[0].name
  }

  spec {
    replicas = var.pokedex_replica_count

    selector {
      match_labels = {
        app = "pokedex"
      }
    }

    template {
      metadata {
        labels = {
          app = "pokedex"
        }
        annotations = {
          "consul.hashicorp.com/connect-inject" = "true"
        }
      }

      spec {
        container {
          image = "jacobmammoliti/pokedex:latest"
          name  = "pokedex"

          args = [
            "-port=8080",
            "-host=127.0.0.1",
          ]
        }

        service_account_name = kubernetes_service_account.pokedex.metadata[0].name
      }
    }
  }
}

resource "kubernetes_pod" "test" {
  metadata {
    name      = "static-client"
    namespace = kubernetes_namespace.pokedex.metadata[0].name

    annotations = {
      "consul.hashicorp.com/connect-inject"            = "true"
      "consul.hashicorp.com/connect-service-upstreams" = "pokedex:8080"
    }
  }

  spec {
    container {
      image = "tutum/curl:latest"
      name  = "static-client"

      command = [
        "/bin/sh",
        "-c",
        "--"
      ]

      args = [
        "while true; do sleep 30; done;"
      ]
    }

    service_account_name = kubernetes_service_account.static-client.metadata[0].name
  }
}