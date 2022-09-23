wordpress-config = {
  deployment_name = "wordpress"
  limit_cpu       = "250m"
  limit_memory    = "2G"
  request_cpu     = "100m"
  request_memory  = "512Mi"
  namespace       = "wordpress"
  volume_name= "wordpress-pv"
  storage= "10Gi"
}
google_domain_name = "ferhatouz.com"
