variable "aws_region" {
  type = string
}


variable "ec2_key_name" {
  type = string
}


variable "projectname" {
  type = string
}

variable "ami" {
    type = string
}

variable "ssh_private_key_path" {
  default = "~/.ssh/id_ed25519"
  type = string
}
