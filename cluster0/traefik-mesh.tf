resource "helm_release" "traefik-mesh" {
  name         = "traefik-mesh"
  repository   = "https://helm.traefik.io/mesh"
  chart        = "traefik-mesh"
  wait         = true
  force_update = false

  values = [templatefile("${path.module}/yaml/traefik-mesh-values.yaml", {
  })]
}
