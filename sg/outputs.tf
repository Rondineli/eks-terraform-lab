output "security_group_eks_master_id" {value="${aws_security_group.eks-poc-cluster.id}"}
output "sg_workers_id"                {value="${aws_security_group.eks-poc-worker-node.id}"}
