resource "helm_release" "traefik-mesh" {
  name         = "traefik-mesh"
//  namespace    = module.common.namespaces.traefik
  repository   = "https://helm.traefik.io/mesh"
  chart        = "traefik-mesh"
  wait         = true
  force_update = false

  values = [templatefile("${path.module}/yaml/traefik-mesh-values.yaml", {
    traefikToken = var.traefik_secrets.token
  })]
}

resource "kubectl_manifest" "traefik-monitor" {
  depends_on = [helm_release.traefik-mesh]
  yaml_body  = file("${path.module}/yaml/k8s/traefik-monitor.yaml")
}

resource "kubernetes_service" "traefik-maesh-service" {
  depends_on = [helm_release.traefik-mesh]

  metadata {
    name      = "traefik-mesh-api"
//    namespace    = module.common.namespaces.traefik

    labels = {
      app       = "maesh"
      component = "maesh-mesh"
      service   = "traefik-maesh"
    }
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 8080
    }

    selector = {
      app       = "maesh"
      component = "maesh-mesh"
    }

    cluster_ip       = "None"
    type             = "ClusterIP"
    session_affinity = "None"
  }
}
