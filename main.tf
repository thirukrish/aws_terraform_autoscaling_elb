provider "aws" {
  region = "us-east-1"
  profile = "thiru-terraform"
}

module "network_module" {
  source = "./network_module"
}

module "loadbalancer" {
  source = "./loadBalancer"
  publicsg_id = "${module.network_module.sg}"
}

module "launch-config" {
  source = "./autoscaling_module"
  pri_sg = "${module.network_module.sg-private}"
  tar_arn = "${module.loadbalancer.tar_grp_arn}"
}