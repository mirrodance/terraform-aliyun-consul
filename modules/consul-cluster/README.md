# Consul Cluster

This folder contains a [Terraform](https://www.terraform.io/) module to deploy a [Consul](https://www.consul.io/) cluster in [Aliyun](https://www.aliyun.com/) on top of a Elastic Scaling Service. This module is designed to deploy a [Aliyun Image](https://help.aliyun.com/document_detail/25389.html) that has Consul installed via the [install-consul](https://github.com/mirrodance/terraform-aliyun-consul/tree/master/modules/install-consul) module in this Module.

## How do you use this module?

This folder defines a [Terraform module](https://www.terraform.io/docs/modules/usage.html), which you can use in your code by adding a `module` configuration and setting its `source` parameter to URL of this folder:

```py
module "consul_cluster" {
  # Use version v0.0.1 of the consul-cluster module
  source = "github.com/mirrodance/terraform-aliyun-consul//modules/consul-cluster?ref=v0.0.1"

  # Specify either the Aliyun Image "family" or a specific Aliyun Image. You should build this using the scripts
  # in the install-consul module.
  source_image = "consul"

  # Configure and start Consul during boot. It will automatically form a cluster with all nodes that have that
  # same tag.
  startup_script = <<-EOF
              #!/bin/bash
              /opt/consul/bin/run-consul --server
              EOF
  
  # ... See variables.tf for the other parameters you must define for the consul-cluster module
}
```

> Aliyun do NOT support `retry-join`, you need to join the cluster manually after the node started.

Note the following parameters:

* `source`: Use this parameter to specify the URL of the consul-cluster module. The double slash (`//`) is intentional and required. Terraform uses it to specify subfolders within a Git repo (see [module sources](https://www.terraform.io/docs/modules/sources.html)). The `ref` parameter specifies a specific Git tag in this repo. That way, instead of using the latest version of this module from the `master` branch, which will change every time you run Terraform, you're using a fixed version of the repo.

* `source_image`: Use this parameter to specify the name of the Consul [Aliyun Image](https://help.aliyun.com/document_detail/25389.html)
  to deploy on each server in the cluster. You should install Consul in this Image using the scripts in the  [install-consul](https://github.com/mirrodance/terraform-aliyun-consul/tree/master/modules/install-consul) module.
  
* `startup_script`: Use this parameter to specify a startup script that each server will run during boot. This is where you can use the [run-consul script](https://github.com/mirrodance/terraform-aliyun-consul/tree/master/modules/run-consul) to configure and run Consul. The `run-consul` script is one of the scripts installed by the [install-consul](https://github.com/mirrodance/terraform-aliyun-consul/tree/master/modules/install-consul) module.

You can find the other parameters in [variables.tf](variables.tf).

Check out the [consul-cluster example](https://github.com/mirrodance/terraform-aliyun-consul/tree/master/examples/consul-cluster) for fully-working sample code.

## How do you connect to the Consul cluster?

### Using the HTTP API from your own computer

If you want to connect to the cluster from your own computer, the easiest way is to use the [HTTP API](https://www.consul.io/docs/agent/http.html). Note that this only works if the Consul cluster is running with `assign_public_ip_addresses` set to `true`, which is OK for testing and experimentation, but NOT recommended for production usage.

To use the HTTP API, you first need to get the public IP address of one of the Consul Servers.

You can use one of these IP addresses with the `members` command to see a list of cluster nodes:

```bash
> consul members -http-addr=11.22.33.44:8500

Node                Address          Status  Type    Build  Protocol  DC
consul-client-5xb8  10.138.0.3:8301  alive   client  0.9.2  2         cn-hongkong
consul-client-m1bz  10.138.0.8:8301  alive   client  0.9.2  2         cn-hongkong
consul-client-xlbb  10.138.0.2:8301  alive   client  0.9.2  2         cn-hongkong
consul-server-45c2  10.138.0.4:8301  alive   server  0.9.2  2         cn-hongkong
consul-server-bm7t  10.138.0.7:8301  alive   server  0.9.2  2         cn-hongkong
consul-server-ntcp  10.138.0.6:8301  alive   server  0.9.2  2         cn-hongkong
```

You can also try inserting a value:

```
> consul kv put -http-addr=11.22.33.44:8500 foo bar

Success! Data written to: foo
```

And reading that value back:
 
```
> consul kv get -http-addr=11.22.33.44:8500 foo

bar
```

Finally, you can try opening up the Consul UI in your browser at the URL `http://11.22.33.44:8500/ui/`.

## What's included in this module?

This module consists of the following resources:

* [Elastic Scaling Service](#elastic-scaling-service)
* [Firewall Rules](#firewall-rules)

### Elastic Scaling Service

This module runs Consul on top of a [Elastic Scaling Service](https://www.aliyun.com/product/ess) Typically, you should run the Instance Group with 3 or 5 Compute Instances spread across multiple zones.

Each of the Compute Instances should be running a Aliyun Image that has Consul installed via the [install-consul](https://github.com/mirrodance/terraform-aliyun-consul/tree/master/modules/install-consul) module. You pass in the name of the Image to run using the `source_image` input parameter.

### Firewall Rules

We create separate Firewall Rules that allow:

* All the inbound ports specified in the [Consul documentation](https://www.consul.io/docs/agent/options.html?#ports-used)
  for use within the Consul Cluster.
* HTTP API requests from aliyun resources that have the given tags or any IP address within the given CIDR Blocks
* DNS requests from aliyun resources that have the given tags or any IP address within the given CIDR Blocks

## What happens if a node crashes?

There are two ways a Consul node may go down:

1. The Consul process may crash. In that case, `supervisor` should restart it automatically.
2. The Compute Instance running Consul stops, crashes, or is otherwise deleted. In that case, the Managed Instance Group
   will launch a replacement automatically.  Note that in this case, although the Consul agent did not exit gracefully,
   the replacement Instance will have the same name and therefore no manual clean out of old nodes is necessary!

## Firewall rules

This module creates Firewall rules that allow inbound requests as follows:

* **Consul**: For all the [ports used by Consul](https://www.consul.io/docs/agent/options.html#ports), all members of the Consul Server cluster will automatically accept inbound traffic in the same security group.

* **External HTTP API Access**: For external access to the Consul Server cluster over the HTTP API port (default: 8500),
  you can use the `allowed_inbound_cidr_blocks_http_api` parameter to control the list of [CIDR blocks](
  https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing).

## What's NOT included in this module?

This module does NOT handle the following items, which you may want to provide on your own:

* [Monitoring, alerting, log aggregation](#monitoring-alerting-log-aggregation)
* [VPCs, subnetworks, route tables](#vpcs-subnetworks-route-tables)
* [DNS entries](#dns-entries)

### Monitoring, alerting, log aggregation

This module does not include anything for monitoring, alerting, or log aggregation.

### VPCs, subnetworks, route tables

This module assumes you've already created your network topology (VPC, subnetworks, route tables, etc). By default,
it will use the "default" network for the Project you select.

### DNS entries

This module does not create any DNS entries for Consul (e.g. with Cloud DNS).
