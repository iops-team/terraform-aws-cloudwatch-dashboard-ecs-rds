# AWS CloudWatch Dashboard Module

This Terraform module facilitates the creation of a CloudWatch dashboard designed for monitoring both Amazon ECS (Elastic Container Service) and Amazon RDS (Relational Database Service) metrics. The module provides a convenient way to visualize crucial performance indicators for ECS services and RDS instances.

## Features

- **CloudWatch Dashboard Setup:** Create a CloudWatch dashboard with customizable widgets tailored for ECS and RDS metrics.
  
- **ECS Monitoring:** Keep an eye on CPU and memory utilization metrics for ECS services.

- **RDS Metrics Tracking:** Track essential RDS metrics, including CPU utilization, database connections, latency, IOPS, storage, and more.

- **Auto Scaling Group Metrics:** Monitor key metrics for Auto Scaling Groups, such as max size, min size, and desired capacity.

## Usage

```hcl
module "ecs_rds_dashboard" {
  source = "iops-team/cloudwatch-dashboard-ecs-rds/aws"

  dashboard_name = "your-dashboard-name"

  cluster_name  = "your-ecs-cluster-name"
  service_names = ["service-1", "service-2"]
  rds_names     = ["your-rds-instance-name"]
  asg_names     = ["your-asg-name"]

  period = 120
}
```

## Inputs

| Name                     | Description                                                                           | Type       | Default             | Required |
|--------------------------|---------------------------------------------------------------------------------------|------------|---------------------|----------|
| `cluster_name`           | The exact name of the ECS cluster to monitor.                                         | string     | ""                  | no       |
| `dashboard_name`         | The name you want to use for this CloudWatch dashboard.                                | string     | ""                  | no       |
| `service_names`          | A list of the exact names of the ECS services to show on the dashboard.                | list(string)| []                  | no       |
| `rds_names`              | The exact name of the RDS instance to monitor.                                         | list(string)| []                  | no       |
| `asg_names`              | A list of the Auto Scaling Group names to show on the dashboard.                        | list(string)| []                  | no       |
| `period`                 | The granularity, in seconds, of the returned data points from CloudWatch.              | number     | 300                 | no       |

## Outputs

| Name                   | Description                                           |
|------------------------|-------------------------------------------------------|
| `dashboard_name`       | CloudWatch dashboard name.                            |
| `dashboard_arn`        | CloudWatch dashboard ARN.                             |
| `dashboard_id`         | CloudWatch dashboard ID.                              |
| `dashboard_body`       | CloudWatch dashboard body.                            |
| `widgets_json`         | JSON representation of the configured dashboard widgets.|

## License

This module is released under the MIT License.
