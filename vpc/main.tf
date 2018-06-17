# All vpc needes
# VPC - Subnets - IG - RT
#
# Let's go!


resource "aws_vpc" "eks_poc" {
  cidr_block        = "10.0.0.0/16"

  tags = "${
    map(
     "Name", "Eks Poc Vpc",
     "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"
}

resource "aws_subnet" "eks_poc" {
  count             = 3 # Each available zone
  vpc_id            = "${aws_vpc.eks_poc.id}"
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = "${var.region}${var.region_number[count.index]}"

  tags = "${
    map(
     "Name", "eks-poc-vpc",
     "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"

}

resource "aws_internet_gateway" "eks_poc" {
  vpc_id = "${aws_vpc.eks_poc.id}"

  tags {
    Name = "eks-poc"
  }
}

resource "aws_route_table" "eks_poc" {
  vpc_id = "${aws_vpc.eks_poc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.eks_poc.id}"
  }
}

resource "aws_route_table_association" "demo" {
  count = 3

  subnet_id      = "${aws_subnet.eks_poc.*.id[count.index]}"
  route_table_id = "${aws_route_table.eks_poc.id}"
}
