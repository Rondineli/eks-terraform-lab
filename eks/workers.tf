resource "aws_launch_configuration" "eks-kubelets-workers-node" {
  associate_public_ip_address = true
  iam_instance_profile        = "${var.instance_profile_name}"
  image_id                    = "${data.aws_ami.eks-worker.id}"
  instance_type               = "t2.xlarge"
  name_prefix                 = "eks-kubelets-"
  security_groups             = ["${var.sg_workers_id}"]
  user_data                   = "${module.user_data.rendered}"
  key_name                    = "${var.key_name}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "kubelets" {
  desired_capacity     = 1
  launch_configuration = "${aws_launch_configuration.eks-kubelets-workers-node.id}"
  max_size             = 3
  min_size             = 1
  name                 = "eks-kubelets-demo"
  vpc_zone_identifier  = ["${var.subnets}"]

  tag {
    key                 = "Name"
    value               = "eks-kuebelets-worker"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
}

