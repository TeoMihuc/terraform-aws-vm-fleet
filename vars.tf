#network
variable "vpc_cidr_block" {
  type = string
}

variable "vpc_tags_name" {
  type = string

}

variable "subnet_cidr_block" {
  type = string
}

variable "subnet_tags_name" {
  type = string

}

variable "avz" {
  type = string
}

#fleet vm
variable "vm-fleet-count" {
  type        = number
  description = "Value on fleet cont needs to be > than 2 and less than 100"

  validation {
    condition     = var.vm-fleet-count > 2 && var.vm-fleet-count < 100
    error_message = "fleet count wasn't repected"
  }
}

variable "vm-fleet-ami" {
  type = string
}

variable "vm-fleet-instance-type" {
  type = string
}

variable "vm-fleet-subnet_id" {
  type    = string
  default = "default"
}

variable "vm-fleet-security-group" {
  type    = string
  default = "default"
}

variable "fleet-private-ips" {
  type    = list(any)
  default = []
}

variable "vm-ssh-user" {
  type = string
  default = "ubuntu"
}

# bastion configurations
variable "public_security_gr" {
  type    = string
  default = "default"
}

variable "bastion-public-dns" {
  type    = string
  default = "default"
}

variable "bastion-private-ssh-key" {
  type    = string
  default = "default"
}

variable "bastion-ami" {
  type    = string
  default = "ami-0a020411eed98341a"
}

variable "bastion-instance-type" {
  type    = string
  default = "t2.micro"
}

variable "bastion-ssh-user" {
  type    = string
  default = "ubuntu"
}