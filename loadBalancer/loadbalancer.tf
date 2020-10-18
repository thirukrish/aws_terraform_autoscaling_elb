
locals {
  env = "${terraform.workspace}"

  ami-id_env = {
    default = "ami-0947d2ba12ee1ff75"
    staging = "ami-0947d2ba12ee1ff75"
    production = "ami-0947d2ba12ee1ff75"
  }
    ami-id ="${lookup(local.ami-id_env,local.env )}"

  key-name_env = {
    default = "staging"
    staging = "staging"
    production = "production"
  }
    key-name = "${lookup(local.key-name_env,local.env )}"
  }



output "ami-id" {
  value = "${local.ami-id_env}"
}

output "key-name" {
  value = "${local.key-name_env}"
}



module "shared_vars" {
  source = "../shared_vars"
}

variable "publicsg_id" {}

resource "aws_lb" "elb" {
  name = "app-lb-${module.shared_vars.env_suffix}"
  internal = "false"
  load_balancer_type = "application"
  security_groups = ["${var.publicsg_id}"]
  subnets = ["${module.shared_vars.privatesubnet1}","${module.shared_vars.privatesubnet2}"]

  enable_deletion_protection = "false"

  tags = {
    Environment = "${module.shared_vars.env_suffix}"
  }
}

resource "aws_lb_target_group" "sampleapp_tg" {
  name = "tg-${module.shared_vars.env_suffix}"
  port = "80"
  protocol = "HTTP"
  vpc_id = "${module.shared_vars.vpcid}"
}

resource "aws_lb_listener" "lbhttp-listener-80" {
  load_balancer_arn = "${aws_lb.elb.arn }"
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.sampleapp_tg.arn}"
  }
}

output "tar_grp_arn" {
  value = "${aws_lb_target_group.sampleapp_tg.arn}"
}