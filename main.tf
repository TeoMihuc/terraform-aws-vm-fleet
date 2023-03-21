# create vpc and subnet for vm fleet
module "fleet-network" {
  source = "./modules/network"

  vpc_cidr_block    = var.vpc_cidr_block
  vpc_tags_name     = var.vpc_tags_name
  subnet_cidr_block = var.subnet_cidr_block
  subnet_tags_name  = var.subnet_tags_name
  avz               = var.avz
}

# create fleet of vms
module "vm-fleet" {
  source = "./modules/vmfleet"

  vm-fleet-count          = var.vm-fleet-count
  vm-fleet-ami            = var.vm-fleet-ami
  vm-fleet-instance-type  = var.vm-fleet-instance-type
  vm-fleet-subnet_id      = module.fleet-network.subnet_id
  avz                     = var.avz
  vm-fleet-security-group = module.fleet-network.internal_security_gr
  public_security_gr      = module.fleet-network.public_security_gr
  vm-ssh-user = var.vm-ssh-user

  bastion-ami           = var.bastion-ami
  bastion-instance-type = var.bastion-instance-type
  bastion-ssh-user      = var.bastion-ssh-user
}
