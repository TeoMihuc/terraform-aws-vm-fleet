output "subnet_id" {
    value = aws_subnet.subnet_fleet.id
}

output "vpc_id" {
    value = aws_vpc.vpc_fleet.id
}

output "internal_security_gr" {
  value     = aws_security_group.private-sg.id
}

output "public_security_gr" {
  value     = aws_security_group.ingress-all.id
}