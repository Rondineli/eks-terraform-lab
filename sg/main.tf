resource "aws_security_group" "eks-poc-cluster" {
  name        = "eks-poc-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "eks-poc-sg"
  }
}


resource "aws_security_group_rule" "eks-poc-cluster" {
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks-poc-cluster.id}"
  source_security_group_id = "${aws_security_group.eks-poc-worker-node.id}"
  to_port                  = 443
  type                     = "ingress"
}



resource "aws_security_group" "eks-poc-worker-node" {
  name        = "eks-workers-node"
  description = "Sg for worker nodes"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
     "Name" = "eks-worker-node"
  }
}

resource "aws_security_group_rule" "eks-poc-worker-node" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.eks-poc-worker-node.id}"
  source_security_group_id = "${aws_security_group.eks-poc-worker-node.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-poc-worker-node-1" {
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks-poc-worker-node.id}"
  source_security_group_id = "${aws_security_group.eks-poc-worker-node.id}"
  to_port                  = 65535
  type                     = "ingress"
}

