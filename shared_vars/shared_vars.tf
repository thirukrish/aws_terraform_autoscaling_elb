




locals {
  env = "${terraform.workspace}"

  vpcid_env = {
    default = "vpc-cc6593b1"
    staging = "vpc-cc6593b1"
    production = "vpc-cc6593b1"
  }
  vpcid = "${lookup(local.vpcid_env, local.env)}"

  publicsubnetid_env = {
    default = "subnet-6212b243"
    staging = "subnet-6212b243"
    production = "subnet-6212b243"
  }
  publicsubnet = "${lookup(local.publicsubnetid_env, local.env )}"

  privatesubnetid_env1 = {
    default = "subnet-dbf68396"
    staging = "subnet-dbf68396"
    production = "subnet-dbf68396"
  }
  privatesubnet1 = "${lookup(local.privatesubnetid_env1, local.env )}"

  privatesubnetid_env2 = {
    default = "subnet-b0618881"
    staging = "subnet-b0618881"
    production = "subnet-b0618881"
  }
  privatesubnet2 = "${lookup(local.privatesubnetid_env2, local.env )}"
}

output "env_suffix" {
  value = "${local.env}"
}

output "vpcid" {
  value = "${local.vpcid}"
}

output "privatesubnet1" {
  value = "${local.privatesubnet1}"
}

output "privatesubnet2" {
  value = "${local.privatesubnet2}"
}
output "publicsubnet" {
  value = "${local.publicsubnet}"
}

