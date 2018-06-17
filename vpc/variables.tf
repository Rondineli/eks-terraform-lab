variable "region" {}
variable "name" {}
variable "cluster_name" {}

variable "region_number" {
  default = {
    "0" = "a"
    "1" = "b"
    "2" = "c"
  }
}
