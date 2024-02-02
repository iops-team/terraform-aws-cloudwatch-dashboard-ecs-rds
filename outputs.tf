output "dashboard_name" {
  value       = try(aws_cloudwatch_dashboard.main[0].dashboard_name, null)
  description = "Cloudwatch dashboard name"
}

output "dashboard_arn" {
  value       = try(aws_cloudwatch_dashboard.main[0].dashboard_arn, null)
  description = "Cloudwatch dashboard ARN"
}

output "dashboard_id" {
  value       = try(aws_cloudwatch_dashboard.main[0].id, null)
  description = "Cloudwatch dashboard ID"
}

output "dashboard_body" {
  value       = try(aws_cloudwatch_dashboard.main[0].dashboard_body, null)
  description = "Cloudwatch dashboard body"
}


output "widgets_json" {
  value = local.widgets
}
