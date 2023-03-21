# network
vpc_cidr_block    = "10.0.0.0/16"
vpc_tags_name     = "vpc-tf"
subnet_cidr_block = "10.0.1.0/24"
subnet_tags_name  = "subnet-tf"
avz               = "eu-west-3a"

# vm fleet
vm-fleet-count         = 3
vm-fleet-ami           = "ami-0a020411eed98341a"
vm-fleet-instance-type = "t2.micro"
vm-ssh-user            = "ubuntu" # this depends on the ami image used

# bastion
bastion-ami           = "ami-0a020411eed98341a"
bastion-instance-type = "t2.micro"
bastion-ssh-user      = "ubuntu" # this depends on the ami image used