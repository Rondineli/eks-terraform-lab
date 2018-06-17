variable "aws_region" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "key_name" {
   default="rondis-key"
}
variable "eks-cluster-name" {
  description = "My Eks Cluster name"
  type="string"
  default="MyEksCluster"
}
