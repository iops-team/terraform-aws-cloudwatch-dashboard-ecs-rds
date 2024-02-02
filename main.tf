data "aws_region" "current" {}

resource "aws_cloudwatch_dashboard" "main" {

  count = var.dashboard_name != "" ? 1 : 0

  dashboard_name = var.dashboard_name
  dashboard_body = jsonencode({
    widgets = local.widgets
  })

}


locals {
  aws_region = data.aws_region.current.name

  ecs_cpu_memory_widget = [for service_name in var.service_names : {
    type   = "metric"
    width  = 12
    height = 8
    properties = {
      view    = "timeSeries"
      stacked = false
      metrics = [
        ["AWS/ECS", "CPUUtilization", "ServiceName", service_name, "ClusterName", var.cluster_name, { color = "#d62728", stat = "Maximum" }],
        [".", "MemoryUtilization", ".", ".", ".", ".", { yAxis = "left", color = "#1f77b4", stat = "Maximum" }]
      ]
      region = local.aws_region,
      annotations = {
        horizontal = [
          {
            color = "#ff0000",
            value = 100
          }
        ]
      }
      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "ECS CPU and Memory Metrics - ${var.cluster_name} / ${service_name}"
      period = var.period
    }
  }]

  rds_cpu_widget = [for db_instance_identifier in var.rds_names : {
    type   = "metric"
    width  = 12
    height = 8
    properties = {
      view    = "timeSeries"
      stacked = false
      metrics = [
        ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", db_instance_identifier, { color = "#d62728", stat = "Maximum" }]
      ]
      region = local.aws_region
      annotations = {
        horizontal = [
          {
            color = "#ff0000",
            value = 100
          }
        ]
      }
      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "RDS CPU Metrics - ${db_instance_identifier}"
      period = var.period
    }
  }]

  rds_db_connections_widget = [for db_instance_identifier in var.rds_names : {
    type   = "metric"
    width  = 4
    height = 4
    properties = {
      view    = "singleValue"
      stacked = false
      metrics = [
        ["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", db_instance_identifier, { color = "#2ca02c", stat = "Maximum" }]
      ]
      region = local.aws_region
      annotations = {
        horizontal = [
          {
            color = "#ff0000",
            value = 50
          }
        ]
      }
      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "RDS Database Connections - ${db_instance_identifier}"
      period = var.period
    }
  }]

  rds_latency_widget = [for db_instance_identifier in var.rds_names : {
    type   = "metric"
    width  = 12
    height = 8
    properties = {
      view    = "timeSeries"
      stacked = false
      metrics = [
        ["AWS/RDS", "ReadLatency", "DBInstanceIdentifier", db_instance_identifier, { color = "#ff7f0e", stat = "Maximum" }],
        ["AWS/RDS", "WriteLatency", "DBInstanceIdentifier", db_instance_identifier, { color = "#8c564b", stat = "Maximum" }]
      ]
      region = local.aws_region

      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "RDS Latency Metrics - ${db_instance_identifier}"
      period = var.period
    }
  }]

  rds_iops_widget = [for db_instance_identifier in var.rds_names : {
    type   = "metric"
    width  = 12
    height = 8
    properties = {
      view    = "timeSeries"
      stacked = false
      metrics = [
        ["AWS/RDS", "ReadIOPS", "DBInstanceIdentifier", db_instance_identifier, { color = "#9467bd", stat = "Maximum" }],
        ["AWS/RDS", "WriteIOPS", "DBInstanceIdentifier", db_instance_identifier, { color = "#17becf", stat = "Maximum" }]
      ]
      region = local.aws_region

      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "RDS IOPS Metrics - ${db_instance_identifier}"
      period = var.period
    }
  }]

  rds_storage_widget = [for db_instance_identifier in var.rds_names : {
    type   = "metric"
    width  = 4
    height = 4
    properties = {
      view    = "singleValue"
      stacked = false
      metrics = [
        ["AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", db_instance_identifier, { color = "#1f77b4", stat = "Maximum" }]
      ]
      region = local.aws_region
      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "RDS Storage Metrics - ${db_instance_identifier}"
      period = var.period
    }
  }]

  asg_metrics_widget = [for asg_name in var.asg_names : {
    type   = "metric"
    width  = 12
    height = 4
    properties = {
      view    = "singleValue"
      stacked = false
      metrics = [
        ["AWS/AutoScaling", "GroupMaxSize", "AutoScalingGroupName", asg_name, { color = "#1f77b4" }],
        ["AWS/AutoScaling", "GroupMinSize", "AutoScalingGroupName", asg_name, { color = "#ff7f0e" }],
        ["AWS/AutoScaling", "GroupDesiredCapacity", "AutoScalingGroupName", asg_name, { color = "#2ca02c" }],
      ]
      region = local.aws_region
      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "ASG Metrics - Max/Min/Desired - ${asg_name}"
      period = var.period
    }
  }]

  rds_cpu_credit_widget = [for db_instance_identifier in var.rds_names : {
    type   = "metric"
    width  = 4
    height = 4
    properties = {
      view    = "pie"
      stacked = true
      metrics = [
        ["AWS/RDS", "CPUCreditBalance", "DBInstanceIdentifier", db_instance_identifier, { color = "#2ca02c", stat = "Sum" }],
        ["AWS/RDS", "CPUCreditUsage", "DBInstanceIdentifier", db_instance_identifier, { color = "#9467bd", stat = "Sum" }],
      ]
      region = local.aws_region

      legend = {
        position = "right"
      }

      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "RDS CPU Credit Metrics - ${db_instance_identifier}"
      period = 60
    }
  }]

  rds_disk_queue_widget = [for db_instance_identifier in var.rds_names : {
    type   = "metric"
    width  = 12
    height = 8
    properties = {
      view    = "timeSeries"
      stacked = false
      metrics = [
        ["AWS/RDS", "DiskQueueDepth", "DBInstanceIdentifier", db_instance_identifier, { color = "#2ca02c", stat = "Maximum" }],
      ]
      region = local.aws_region

      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "RDS Disk Queue Depth - ${db_instance_identifier}"
      period = var.period
    }
  }]

  rds_ebs_byte_balance_widget = [for db_instance_identifier in var.rds_names : {
    type   = "metric"
    width  = 12
    height = 8
    properties = {
      view    = "timeSeries"
      stacked = false
      metrics = [
        ["AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", db_instance_identifier, { color = "#1f77b4", stat = "Maximum" }],
        ["AWS/RDS", "VolumeBytesBalance", "DBInstanceIdentifier", db_instance_identifier, { color = "#ff7f0e", stat = "Average" }],
      ]
      region = local.aws_region

      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "RDS EBS Byte Balance - ${db_instance_identifier}"
      period = var.period
    }
  }]


  rds_freeable_memory_widget = [for db_instance_identifier in var.rds_names : {
    type   = "metric"
    width  = 12
    height = 8
    properties = {
      view    = "timeSeries"
      stacked = false
      metrics = [
        ["AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", db_instance_identifier, { color = "#d62728", stat = "Average" }],
      ]
      region = local.aws_region

      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "RDS Freeable Memory - ${db_instance_identifier}"
      period = var.period
    }
  }]


  widgets = concat(local.ecs_cpu_memory_widget, local.asg_metrics_widget, local.rds_storage_widget, local.rds_db_connections_widget, local.rds_cpu_credit_widget, local.rds_cpu_widget, local.rds_disk_queue_widget, local.rds_latency_widget, local.rds_iops_widget, local.rds_freeable_memory_widget)

}
