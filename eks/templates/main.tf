data "template_file" "user_data" {
  template = "${file("${path.module}/files/userdata.tpl")}"

  vars {
    ca_certificate       = "${var.ca_certificate}"
    eks_master_endpoint  = "${var.eks_master_endpoint}"
    cluster_name         = "${var.cluster_name}"
    region               = "${var.region}"
  }
}

