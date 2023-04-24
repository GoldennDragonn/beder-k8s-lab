variable "region" {
  description = "AWS Region"
  default = "eu-west-1"
}

variable "ami" {
  description = "Ubuntu 20.04 AMI (x86_64)"
  default = "ami-04e2e94de097d3986"
}

variable "instance_type" {
  description = "Instance type"
  default = "t3.medium"
}

variable "ssh_public_key" {
  description = "SSH public key path"
  default = "/home/yakovbe/.ssh/id_rsa.pub"
}

variable "ssh_private_key" {
  description = "SSH private key path"
  default = "/home/yakovbe/.ssh/id_rsa"
}
