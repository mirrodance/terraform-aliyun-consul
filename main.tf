provider "alicloud" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

terraform {
  required_version = ">= 0.10.0"
}

module "consul_servers" {
  # source = "modules/consul-cluster"
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  source = "github.com/mirrodance/terraform-aliyun-consul//modules/consul-cluster?ref=v0.0.1"

  cluster_name  = "${var.consul_cluster_name}"
  cluster_size  = "${var.consul_cluster_size}"
  ssh_key_name  = "${var.ssh_key_name}"
  image_id      = "${var.consul_image_id}"
  user_data     = "${base64encode(data.template_file.user_data_server.rendered)}"
  vpc_id        = "${data.alicloud_vpcs.default.vpcs.0.id}"
  vswitch_ids   = ["${data.alicloud_vswitches.default.vswitches.0.id}"]
  instance_type = "ecs.xn4.small"
}

data "template_file" "user_data_server" {
  template = "${file("${path.module}/examples/root-example/user-data-server.sh")}"
}

data "alicloud_vpcs" "default" {
  is_default = "${var.use_default_vpc}"
}

data "alicloud_vswitches" "default" {
  vpc_id = "${data.alicloud_vpcs.default.vpcs.0.id}"
}
