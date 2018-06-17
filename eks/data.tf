data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["eks-worker-*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon Account ID
}

module "user_data" {
  source                = "./templates"
  ca_certificate        = "${aws_eks_cluster.eks-poc-master.certificate_authority.0.data}"
  eks_master_endpoint   = "${aws_eks_cluster.eks-poc-master.endpoint}"
  cluster_name          = "${var.cluster_name}"
  region                = "${var.region}"
}
