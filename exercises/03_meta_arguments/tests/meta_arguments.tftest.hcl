# Spec for exercise 03. Run with: make check EX=03_meta_arguments
# The AWS provider is mocked: no cloud, no credentials. Data sources return the defaults below.

mock_provider "aws" {
  mock_data "aws_ami" {
    defaults = { id = "ami-0123456789abcdef0" }
  }
  mock_data "aws_availability_zones" {
    defaults = { names = ["eu-west-2a", "eu-west-2b"] }
  }
}

run "one_instance_per_name" {
  command = plan

  assert {
    condition     = toset(keys(aws_instance.app)) == toset(["api", "web"])
    error_message = "aws_instance.app should use for_each over instance_names (keys web and api)."
  }

  assert {
    condition     = aws_instance.app["web"].tags["Name"] == "dev-web"
    error_message = "Each instance should be tagged Name = <environment>-<name>."
  }
}

run "uses_the_data_sources" {
  command = plan

  assert {
    condition     = alltrue([for i in aws_instance.app : i.ami == "ami-0123456789abcdef0"])
    error_message = "Instances should take their AMI from data.aws_ami.base."
  }

  assert {
    condition     = alltrue([for i in aws_instance.app : i.availability_zone == "eu-west-2a"])
    error_message = "Instances should go in the first available AZ from data.aws_availability_zones.available."
  }
}

run "dynamic_ingress_per_port" {
  command = plan

  variables {
    allowed_ports = [80, 443, 8080]
  }

  assert {
    condition     = toset([for r in aws_security_group.web.ingress : r.from_port]) == toset([80, 443, 8080])
    error_message = "The security group should have one ingress rule per allowed port (dynamic block)."
  }

  assert {
    condition     = alltrue([for r in aws_security_group.web.ingress : r.protocol == "tcp" && r.to_port == r.from_port])
    error_message = "Each ingress rule should be TCP for a single port."
  }
}

run "dev_gets_micro" {
  command = plan

  assert {
    condition     = alltrue([for i in aws_instance.app : i.instance_type == "t3.micro"])
    error_message = "Non-prod environments should use t3.micro."
  }
}

run "prod_gets_small" {
  command = plan

  variables {
    environment = "prod"
  }

  assert {
    condition     = alltrue([for i in aws_instance.app : i.instance_type == "t3.small"])
    error_message = "prod should use t3.small (conditional expression)."
  }
}

run "outputs_after_apply" {
  command = apply

  assert {
    condition     = output.ami_id == "ami-0123456789abcdef0"
    error_message = "Output ami_id should be the AMI ID from the data source."
  }

  assert {
    condition     = toset(keys(output.instance_ids)) == toset(["api", "web"]) && output.instance_ids["web"] == aws_instance.app["web"].id
    error_message = "Output instance_ids should be a map of name => instance ID."
  }
}
