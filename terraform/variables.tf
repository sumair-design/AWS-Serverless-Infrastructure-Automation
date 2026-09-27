variable "aws_region" {
  description = "AWS region for the automation stack."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used for resource naming and tags."
  type        = string
  default     = "serverless-ec2-automation"
}

variable "environment" {
  description = "Environment label."
  type        = string
  default     = "nonprod"
}

variable "schedule_tag_key" {
  description = "EC2 tag key used to opt an instance into automation."
  type        = string
  default     = "AutoSchedule"
}

variable "schedule_tag_value" {
  description = "EC2 tag value used to opt an instance into automation."
  type        = string
  default     = "true"
}

variable "start_schedule" {
  description = "EventBridge cron expression for starting instances. UTC."
  type        = string
  default     = "cron(30 7 ? * SUN-THU *)"
}

variable "stop_schedule" {
  description = "EventBridge cron expression for stopping instances. UTC."
  type        = string
  default     = "cron(30 14 ? * SUN-THU *)"
}

variable "lambda_runtime" {
  type    = string
  default = "python3.12"
}
