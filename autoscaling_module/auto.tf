variable "pri_sg" {}


resource "aws_launch_configuration" "new-launchconfig" {
  name = "new-launch-config-${local.env}"
  image_id = "${local.ami-id}"
  instance_type = "t2.micro"
  key_name = "${local.key-name}"
  security_groups = [
    "${var.pri_sg}"]
  user_data = "${file("/assets/userdat.txt")}"

}
module "shared-vars" {
  source = "../shared_vars"
}
locals {
  env = "${terraform.workspace}"
ami-id_env = {
  default = "ami-0947d2ba12ee1ff75"
  staging = "ami-0947d2ba12ee1ff75"
  production = "ami-0947d2ba12ee1ff75"
}
  ami-id = "${lookup(local.ami-id_env,local.env )}"

  key-name_env = {
    default = "staging"
    staging = "production"
    production = "production"
  }
  key-name = "${lookup(local.key-name_env,local.env )}"
}

resource "aws_autoscaling_group" "suto_sg" {
  max_size = 3
  min_size = 2
  launch_configuration = "${aws_launch_configuration.new-launchconfig.name}"
  vpc_zone_identifier = ["${module.shared-vars.privatesubnet1},${module.shared-vars.privatesubnet2}"]
  target_group_arns = ["${var.tar_arn}"]
}

variable "tar_arn"{}
