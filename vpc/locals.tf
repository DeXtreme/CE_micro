locals {
  public_subnets = flatten([for az,cidrs in var.public_subnets:
                    [for cidr in cidrs:{
                        az = az
                        cidr = cidr
                    }]
                ])

private_subnets = flatten([for az,cidrs in var.private_subnets:
                [for cidr in cidrs:{
                    az = az
                    cidr = cidr
                }]
            ])
}