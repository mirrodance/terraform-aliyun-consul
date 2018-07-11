# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_name" {
  description = "The name of the scaling group."
}

variable "cluster_size" {
  description = "The number of ECS instances."
}

variable "image_id" {
  description = "The ID of the IMAGE to run in this cluster. Should be an IMAGE that had Vault installed and configured by the install-vault module."
}

variable "instance_type" {
  description = "The type of ECS Instances to run for each node in the cluster (e.g. ecs.n4.large)."
}

variable "vpc_id" {
  description = "The ID of the VPC in which to deploy the cluster"
}

variable "ssh_key_name" {
  description = "ssh key name."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "vswitch_ids" {
  description = "The vswitches id in which the ECS instance launched."
  type        = "list"
  default     = []
}

variable "allowed_inbound_cidr_blocks_http_api" {
  description = "A list of CIDR-formatted IP address ranges from which the Compute Instances will allow API connections to Consul."
  default     = "0.0.0.0/0"
}

variable "removal_policies" {
  description = "The removal policy used to select the ECS instance to remove from the scaling group."
  default     = ["OldestScalingConfiguration", "OldestInstance"]
}

variable "user_data" {
  description = "A User Data script to execute while the server is booting. We remmend passing in a bash script that executes the run-consul script, which should have been installed in the Consul image by the install-consul module."
}
