resource "aws_iam_role" "eks-poc-cluster" {
  name = "eks-poc-cluster"
  assume_role_policy = "${file("${path.module}/files/eks-poc-cluster.json")}"
}

resource "aws_iam_role" "eks-poc-worker-node" {
  name = "eks-poc-worker-node"
  assume_role_policy = "${file("${path.module}/files/ec2-eks-poc-cluster.json")}"
}

resource "aws_iam_role_policy_attachment" "eks-poc-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.eks-poc-worker-node.name}"
}

resource "aws_iam_role_policy_attachment" "eks-poc-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.eks-poc-worker-node.name}"
}

resource "aws_iam_role_policy_attachment" "eks-poc-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.eks-poc-worker-node.name}"
}

resource "aws_iam_instance_profile" "eks-poc-worker-node" {
  name = "eks-poc-worker-node"
  role = "${aws_iam_role.eks-poc-worker-node.name}"
}
