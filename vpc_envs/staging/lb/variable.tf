variable "default_tags" {
  default = {
    Owner = "Group 2",
    App   = "Web"
  }
  type        = map(any)
  description = "Default tags for all AWS resources"
}

variable "prefix" {
  default     = "staging"
  type        = string
  description = "Name prefix"
}

variable "env" {
  default     = "staging"
  type        = string
  description = "Deployment Environment"
}
