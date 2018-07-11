output "vpc_id" {
  value = "${data.alicloud_vpcs.default.id}"
}
