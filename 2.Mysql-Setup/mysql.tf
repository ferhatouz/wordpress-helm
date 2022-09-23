resource "random_password" "mysql" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
module "mysql-terraform-k8s-namespace" {
  source               = "./modules/terraform-k8s-namespace/"
  deployment_namespace = "wordpress"
}

module "mysql-helm" {
    source = "./modules/terraform-helm/"
    deployment_name = var.mysql-config["deployment_name"]
    deployment_namespace = "wordpress"
    deployment_path      = "charts/mysql"
    values_yaml          = <<EOF
fullnameOverride: mysql
auth:
    password: "mzvAfHjyEy"
    rootPassword: "${random_password.mysql.result}"
primary:
    resources: 
    limits:
        cpu: "${var.mysql-config["limit_cpu"]}"
        memory: "${var.mysql-config["limit_memory"]}"
    requests:
        cpu: "${var.mysql-config["request_cpu"]}"
        memory: "${var.mysql-config["request_memory"]}"
    EOF
    }

# resource "vault_mount" "mysql" {
#   path        = "mysql"
#   type        = "kv"
#   options     = { version = "1" }
# }

# resource "vault_kv_secret" "mysql" {
#   path = "${vault_mount.mysql.path}/secret"
#   data_json = jsonencode(
#   {
#     rootpass = "${random_password.mysql.result}"
#   }
#   )
# }
    