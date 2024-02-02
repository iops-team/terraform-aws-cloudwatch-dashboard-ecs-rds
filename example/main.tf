module "ecs_dashboard" {
  source = "../"

  cluster_name   = "cluster_name"
  dashboard_name = "dashboard_name"
  service_names  = ["service-1", "service-2"]
  rds_names      = ["rds_name"]
  asg_names      = ["asg_name"]
  period         = 120

}
