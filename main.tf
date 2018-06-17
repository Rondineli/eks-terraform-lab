provider "aws" {
      region                                 = "${var.aws_region}"
      access_key                             = "${var.aws_access_key}"
      secret_key                             = "${var.aws_secret_key}"
      version                                = ">= 1.2.0"
}


module "vpc" {
      region                                 = "${var.aws_region}"
      name                                   = "vpc"
      source                                 = "./vpc"
      cluster_name                           = "${var.eks-cluster-name}"
}

module "policy" {
      source                                 = "./policy"
}

module "sg" {
      source                                 = "./sg"
      vpc_id                                 = "${module.vpc.vpc_id}"
}

module "eks" {
      source                                 = "./eks"
      subnets                                = "${module.vpc.subnets}"
      security_group_eks_master_id           = "${module.sg.security_group_eks_master_id}"
      sg_workers_id                          = "${module.sg.sg_workers_id}"
      role_arn                               = "${module.policy.role_arn}"
      role_name                              = "${module.policy.role_name}"
      instance_profile_name                  = "${module.policy.instance_profile_name}"
      cluster_name                           = "${var.eks-cluster-name}"
      region                                 = "${var.aws_region}"
      key_name                               = "${var.key_name}"
}
