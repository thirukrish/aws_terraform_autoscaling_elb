

module "shared_vars" {
  source = "../shared_vars"
}

resource "aws_security_group" "public_sg" {
  name = "elb_security_group-${module.shared_vars.env_suffix}"
  description = "sg for elb-${module.shared_vars.env_suffix}"
  vpc_id = "${module.shared_vars.vpcid}"
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name ="ELB_security_group-${module.shared_vars.env_suffix}"
  }
}

resource "aws_security_group" "ec2_private_sg" {
  name = "ec2_security_group-${module.shared_vars.env_suffix}"
  description = "ec2_sg for ec2-${module.shared_vars.env_suffix}"
  vpc_id = "${module.shared_vars.vpcid}"
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    security_groups = ["${aws_security_group.public_sg.id}"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name ="ec2_security_group-${module.shared_vars.env_suffix}"
  }
}

output "sg" {
  value = "${aws_security_group.public_sg.id}"
}

output "sg-private" {
  value = "${aws_security_group.ec2_private_sg.id}"
}