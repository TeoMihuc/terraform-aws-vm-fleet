variable "vm-fleet-count" {
  type = number
}

variable "vm-fleet-ami" {
  type = string
}

variable "vm-fleet-instance-type" {
  type = string
}

variable "vm-fleet-subnet_id" {
  type = string
}

variable "avz" {
  type = string
}

variable "vm-fleet-security-group" {
  type = string
}

variable "vm-ssh-user" {
  type = string
}

# bastion

variable "public_security_gr" {
  type    = string
}

variable "bastion-ami" {
  type    = string
}

variable "bastion-instance-type" {
  type    = string
}

variable "bastion-ssh-user" {
  type    = string
}