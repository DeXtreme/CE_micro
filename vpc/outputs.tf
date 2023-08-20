output "vpc_id" {
    value = aws_vpc.vpc.id
    description = "The vpc id"
}

output "public_subnets" {
    value = aws_subnet.public
    description = "The list public subnets"
}

output "private_subnets" {
    value = aws_subnet.private
    description = "The list private subnets"
}

