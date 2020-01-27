variable "ami_id" {
  description = "the input ami id"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "the target vpc id"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "the target subnet id"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "the aws keypair name"
  type        = string
  default     = ""
}

variable "name" {
  description = "a label that identifies to all resources"
  type        = string
}

variable "tags" {
  description = "a map of tags applied to all taggable resources"
  type        = map(string)
  default     = {}
}

module "security_group" {
  source = "github.com/garyellis/tf_module_aws_security_group"

  name                     = var.name
  description              = var.name
  toggle_allow_all_egress  = true
  toggle_allow_all_ingress = true
  tags                     = var.tags
  vpc_id                   = var.vpc_id
}

module "ec2_instance" {
  source = "github.com/garyellis/tf_module_aws_instance?ref=v1.1.0"

  name                       = var.name
  count_instances            = 1
  ami_id                     = var.ami_id
  instance_type              = "t3.large"
  key_name                   = var.key_name
  security_group_attachments = list(module.security_group.security_group_id)
  subnet_ids                 = list(var.subnet_id)
  tags                       = var.tags
}

output "ami_id" {
  value = var.ami_id
}

output "private_ip" {
  value = join("", module.ec2_instance.aws_instance_private_ips)
}
