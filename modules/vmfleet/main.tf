resource "tls_private_key" "bastion-ssh-key-pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion-ssh-key" {
  key_name   = "bastion-key"
  public_key = tls_private_key.bastion-ssh-key-pair.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.bastion-ssh-key-pair.private_key_pem}' > ./bastion-ssh-key-pair.pem"
  }
}

resource "aws_instance" "bastion" {
  ami           = var.bastion-ami
  instance_type = var.bastion-instance-type
  subnet_id = var.vm-fleet-subnet_id
  availability_zone = var.avz

  associate_public_ip_address = true
  key_name = aws_key_pair.bastion-ssh-key.key_name

  vpc_security_group_ids = [ var.public_security_gr ]

  tags = {
    Name = "bastion"
  }
}

resource "tls_private_key" "pem" {
  count = var.vm-fleet-count
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  count = var.vm-fleet-count
  key_name   = "myKey-${count.index}"
  public_key = tls_private_key.pem[count.index].public_key_openssh
}

resource "aws_instance" "fleet_instances" {
  depends_on = [
    aws_instance.bastion
  ]

  count = var.vm-fleet-count
  ami = var.vm-fleet-ami
  instance_type = var.vm-fleet-instance-type

  subnet_id = var.vm-fleet-subnet_id
  availability_zone = var.avz

  key_name = aws_key_pair.kp[count.index].key_name
  vpc_security_group_ids = [ var.vm-fleet-security-group ]
  
  tags = {
    Name = "fleet-${count.index}"
  }

  connection {
    type     = "ssh"
    user     = var.bastion-ssh-user
    private_key = tls_private_key.bastion-ssh-key-pair.private_key_pem
    host     = aws_instance.bastion.public_dns
  }

  provisioner "remote-exec" {
    inline = [
      "echo '${tls_private_key.pem[count.index].private_key_pem}' > /tmp/myKey-${count.index}.pem",
      "chmod 400 /tmp/myKey-${count.index}.pem"
    ]
  }
}

locals {
    list_ip = join(" ", aws_instance.fleet_instances[*].private_dns)
}

resource "null_resource" "ping" {
  depends_on = [
    aws_instance.bastion, aws_instance.fleet_instances
  ]
  connection {
    type     = "ssh"
    user     =  var.bastion-ssh-user
    private_key = tls_private_key.bastion-ssh-key-pair.private_key_pem
    host     = aws_instance.bastion.public_dns
  }

  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x  /tmp/script.sh",
      "echo ${local.list_ip} > /tmp/list-private-ip.txt",
      "/bin/bash /tmp/script.sh ${var.vm-ssh-user}"
    ]
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}