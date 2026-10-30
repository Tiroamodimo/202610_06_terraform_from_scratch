terraform {
  required_version = ">= 1.10"
  backend "local" {} # path set per target + account by the sandbox kit (make plan/apply)
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.100"
    }
  }
}

# Region and credentials come from the environment (sandbox kit), never from code.
provider "aws" {
  default_tags {
    tags = {
      Project  = "tf-from-scratch"
      Exercise = "03"
    }
  }
}

# TODO 1: variables environment, instance_names, allowed_ports, ami_name_pattern

# TODO 2: data "aws_ami" "base" and data "aws_availability_zones" "available"

# TODO 3: resource "aws_security_group" "web" with a dynamic "ingress" block

# TODO 4: resource "aws_instance" "app" with for_each and a conditional instance_type

# TODO 5: outputs ami_id and instance_ids (map of name => id)
