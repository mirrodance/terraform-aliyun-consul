output "ess_name" {
  value = "${alicloud_ess_scaling_group.autoscaling_group.scaling_group_name}"
}

output "cluster_size" {
  value = "${alicloud_ess_scaling_group.autoscaling_group.min_size}"
}

output "security_groupd_id" {
  value = "${alicloud_security_group.security_group.id}"
}
