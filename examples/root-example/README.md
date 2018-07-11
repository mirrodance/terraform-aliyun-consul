# Consul Cluster Example

This folder shows an example of Terraform code that uses the [consul-cluster](https://github.com/mirrodance/terraform-aliyun-consul/tree/master/modules/consul-cluster) module to deploy a [Consul](https://www.consul.io/) cluster in [Aliyun Cloud](https://www.aliyun.com/). The cluster consists of two Elastic Scaling Services: one with Consul server nodes, which are responsible for being part of the [consensus quorum](https://www.consul.io/docs/internals/consensus.html), and one with client nodes, which would typically run alongside your apps:

You will need to create a [Aliyun Image](https://help.aliyun.com/document_detail/25389.html) that has Consul installed, which you can do using the [consul-image example](https://github.com/mirrodance/terraform-aliyun-consul/tree/master/examples/consul-image)). Note that to keep this example simple, both the server Instance Group and client Instance Group are running the exact same Custom Image. In real-world usage, you'd probably have multiple client Instance Groups, and each of those Instance Groups would run a
different Custom Image that has the Consul agent installed alongside your apps.

For more info on how the Consul cluster works, check out the [consul-cluster](https://github.com/mirrodance/terraform-aliyun-consul/tree/master/modules/consul-cluster) documentation.

## Quick start

To deploy a Consul Cluster:

1. `git clone` this repo to your computer.
2. Build a Consul Custom Image. See the [consul-image example](https://github.com/mirrodance/terraform-aliyun-consul/tree/master/examples/consul-image) documentation for instructions. Make sure to note down the ID of the Custom Image.
3. Install [Terraform](https://www.terraform.io/).
4. Open `variables.tf` and fill in any other variables that don't have a default, including putting your Custom Image ID into
   the `image_id` variable.
5. Run `terraform init`.
6. Run `terraform get`.
7. Run `terraform plan`.
8. If the plan looks good, run `terraform apply`.