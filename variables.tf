variable "period" {
  type    = number
  default = 300
}

variable "dashboard_name" {
  description = "The name you want to use for this CloudWatch dashboard"
  type        = string
  default     = null
}

variable "cluster_name" {
  description = "The exact name of the cluster"
  type        = string
  default     = null
}

variable "service_names" {
  description = "A list of the exact names of the services to show on the dashboard"
  type        = list(string)
  default     = []
}

variable "rds_names" {
  description = "The exact name of the RDS"
  type        = list(string)
  default     = []
}

variable "asg_names" {
  description = "A list of the Auto Scaling Group names to show on the dashboard"
  type        = list(string)
  default     = []
}


