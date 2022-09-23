provider "kubernetes" {
  config_path    = "~/.kube/config"
}
resource "random_password" "wordpress" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "wordpress-helm" {
    source = "./modules/terraform-helm/"
    deployment_name = var.wordpress-config["deployment_name"]
    deployment_namespace = "wordpress"
    deployment_path      = "charts/wordpress"
    values_yaml          = <<EOF
ingress:
  enabled: true
  hosts:
    - name: "wordpress.${var.google_domain_name}"
      path: /
  annotations: 
    nginx.ingress.kubernetes.io/proxy-body-size: "64m"
    ingress.kubernetes.io/ssl-redirect: "false"
    cert-manager.io/cluster-issuer: letsencrypt-prod
    acme.cert-manager.io/http01-edit-in-place: "true"
  ingressClassName: nginx
  tls: 
    - secretName: wordpress
      hosts:
        - "wordpress.${var.google_domain_name}"
fullnameOverride: "${var.wordpress-config["deployment_name"]}"

wordpressUsername: user

wordpressPassword: "${random_password.wordpress.result}"

resources: 
    limits:
      cpu: "${var.wordpress-config["limit_cpu"]}"
      memory: "${var.wordpress-config["limit_memory"]}"
    requests:
      cpu: "${var.wordpress-config["request_cpu"]}"
      memory: "${var.wordpress-config["request_memory"]}"
    
persistence:
    enable: false
    existingClaim: "${var.wordpress-config["volume_name"]}"
externalDatabase:
    host:
    port:3306
    user:
    EOF
    }
resource "kubernetes_persistent_volume_claim" "wordpress" {
  metadata {
    name      = var.wordpress-config["volume_name"]
    namespace = var.wordpress-config["namespace"]
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.wordpress-config["storage"]
      }
    }
    storage_class_name = "standard"
  }
}

# resource "vault_mount" "wordpress" {
#   path        = "wordpress"
#   type        = "kv"
#   options     = { version = "1" }
# }

# resource "vault_kv_secret" "wordpress" {
#   path = "${vault_mount.wordpress.path}/secret"
#   data_json = jsonencode(
#   {
#     wbpass = "${random_password.wordpress.result}"
#   }
#   )
# }
    