output "vpc_id"  {value="${aws_vpc.eks_poc.id}"} 
output "subnets" {value=["${aws_subnet.eks_poc.*.id}"]}
