mysql-config = {
  deployment_name = "mysql"
  limit_cpu       = "250m"
  limit_memory    = "2G"
  request_cpu     = "100m"
  request_memory  = "512Mi"
  namespace       = "wordpress"
}