variable "autopilot_enabled" {
  type        = bool
  default     = false
  description = "autopilot : true/false"
}

variable "cluster_type" {
  type        = string
  default     = ""
  description = "cluster type : zonal regional"
}