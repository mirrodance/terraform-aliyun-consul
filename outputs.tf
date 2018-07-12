output "vpc_id" {
  value = "${data.alicloud_vpcs.default.id}"
}

output "security_groupd_id" {
  value = "${module.consul_servers.security_group_id}"
}
