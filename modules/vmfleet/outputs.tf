output "bastion-public-dns" {
    value = aws_instance.bastion.public_dns
}

output "bastion-private-ssh-key" {
    value = tls_private_key.bastion-ssh-key-pair.private_key_pem
}

output "fleet-private-ips" {
    value = aws_instance.fleet_instances[*].private_dns
}