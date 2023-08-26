variable "region" {
  type        = string
  description = "The region to use"
  default     = "us-east-1"
}

variable "instance" {
  type = object({
    ami           = string
    instance_type = string
  })
  description = "The instance details"
  default = {
    ami           = "ami-0e692fe1bae5ca24c"
    instance_type = "t2.micro"
  }
}


variable "key_name" {
  type        = string
  description = "The key name to use"
}

variable "vpc_cidr" {
  type        = string
  description = "The cidr of the vpc"
  default     = "10.0.0.0/16"
}


variable "public_subnets" {
  type = map(set(string))
  default = {
    us-east-1a = ["10.0.0.0/24"]
    us-east-1b = ["10.0.1.0/24"]
  }
}

