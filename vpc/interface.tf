variable "name" {
  type        = string
  description = "Name of vpc"
  default     = "vpc"
}

variable "cidr" {
  type        = string
  description = "Network address of vpc"
}

variable "public_subnets" {
  type        = map(set(string))
  description = "A map of AZs and the public subnets to create in them"
  default     = {}
}

variable "private_subnets" {
  type        = map(set(string))
  description = "A map of AZs and the private subnets to create in them"
  default     = {}
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "enable_dns_support" {
  type    = bool
  default = true
}


