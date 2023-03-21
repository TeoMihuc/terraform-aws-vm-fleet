# Terraform code for AWS instance spin up
- this repo holds the code to create a full infrastructure in AWS to deploy a configurable amount of VMs
- a monitoring solution is implemented after the VMs are up. Each VM will ping in a round-robbin manner other VM

## General overview
This repository is divided in terraform modules:
1. Module: network -> creates the VPC and the subnet in which the VMs will be created (+ internet gw)
2. Module: vmfleet -> creates a bastion vm with public IP and generates a ssh key for it stored in AWS key pairs. Same thing done for each vm from the fleet, but the fleet vms are private
    - security groups were created, one for the bastion VM and one for the fleet
    - each ssk key for the vm fleet is saved on the bastion host in a specific location
    - at the end, a nul_resource is used in order to simulate a roundrobbin fashion of pinging the VMs in the fleet
    - the local script.sh file contains the script for round-robbin ping fashion
## Variables
Notable variables:
- the VM type and VM ami are configurable from the .tfvars file (for both bastion and fleet vm)
- the number of the VM fleet is configured in tfvars and has a validation rule on it -> this can take values between 2 and 100