module "sonarqube-terraform-k8s-namespace" {
  source               = "./modules/terraform-k8s-namespace/"
  deployment_namespace = "sonarqube"
}

module "sonarqube-terraform-helm" {
  source               = "./modules/terraform-helm/"
  deployment_name      = "sonarqube"
  deployment_namespace = "sonarqube"
  deployment_path      = "charts/sonarqube/"
  values_yaml          = <<EOF

ingress:
  enabled: true
  hosts:
    - name: "sonarqube1.${var.google_domain_name}"
      path: /
  annotations: 
    nginx.ingress.kubernetes.io/proxy-body-size: "64m"
    ingress.kubernetes.io/ssl-redirect: "false"
    cert-manager.io/cluster-issuer: letsencrypt-prod
    acme.cert-manager.io/http01-edit-in-place: "true"
  ingressClassName: nginx
  tls: 
    - secretName: sonarqube1
      hosts:
        - "sonarqube1.${var.google_domain_name}"
EOF
}

