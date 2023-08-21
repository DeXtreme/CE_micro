locals {
  public_subnets  = { for cidr, az in transpose(var.public_subnets) : cidr => one(az) }
  private_subnets = { for cidr, az in transpose(var.private_subnets) : cidr => one(az) }
}