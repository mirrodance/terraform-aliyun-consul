terraform {
  required_version = ">= 0.10.3"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A SCALING GROUP (ESS) TO RUN VAULT
# ---------------------------------------------------------------------------------------------------------------------

resource "alicloud_ess_scaling_group" "autoscaling_group" {
  scaling_group_name = "${var.cluster_name}"

  vswitch_ids = ["${var.vswitch_ids}"]

  # Use a fixed-size cluster
  min_size         = "${var.cluster_size}"
  max_size         = "${var.cluster_size}"
  removal_policies = ["${var.removal_policies}"]
}

resource "alicloud_ess_scaling_configuration" "config" {
  scaling_group_id = "${alicloud_ess_scaling_group.autoscaling_group.id}"

  image_id      = "${var.image_id}"
  instance_type = "${var.instance_type}"
  user_data     = "${var.user_data}"

  key_name          = "${var.ssh_key_name}"
  security_group_id = "${alicloud_security_group.security_group.id}"
  active            = true
}

resource "alicloud_security_group" "security_group" {
  name        = "${var.cluster_name}"
  description = "Security group for the ${var.cluster_name} scaling configuration"
  vpc_id      = "${var.vpc_id}"
}

resource "alicloud_security_group_rule" "allow_api_port" {
  type        = "egress"
  nic_type    = "intranet"
  ip_protocol = "tcp"
  port_range  = "8500/8500"
  policy      = "accept"

  cidr_ip           = "${var.allowed_inbound_cidr_blocks_http_api}"
  security_group_id = "${alicloud_security_group.security_group.id}"
}
