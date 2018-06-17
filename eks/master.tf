resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${var.role_name}"
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${var.role_name}"
}

resource "aws_eks_cluster" "eks-poc-master" {
  name            = "${var.cluster_name}"
  role_arn        = "${var.role_arn}"

  vpc_config {
    security_group_ids = ["${var.security_group_eks_master_id}"]
    subnet_ids         = ["${var.subnets}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.eks-cluster-AmazonEKSServicePolicy",
    "aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy",
  ]
}

locals {
  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.eks-poc-master.endpoint}
    certificate-authority-data: ${aws_eks_cluster.eks-poc-master.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: heptio-authenticator-aws
      args:
        - "token"
        - "-i"
        - "${var.cluster_name}"
KUBECONFIG
}
