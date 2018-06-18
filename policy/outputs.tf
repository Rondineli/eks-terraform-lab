output "role_arn"                {value="${aws_iam_role.eks-poc-cluster.arn}"}
output "role_name"               {value="${aws_iam_role.eks-poc-cluster.name}"}
output "instance_profile_name"   {value="${aws_iam_instance_profile.eks-poc-worker-node.name}"}
output "instance_profile_arn"    {value="${aws_iam_instance_profile.eks-poc-worker-node.arn}"}
