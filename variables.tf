variable "access_key" {
  description = "Access Key."
}

variable "secret_key" {
  description = "Secret Key."
}

variable "region" {
  description = "The region in which all resources will be lanched."
  default     = "cn-hongkong"
}

variable "ssh_key_name" {
  description = "ssh key name."
}

variable "consul_image_id" {
  description = "The ID of the IMAGE to run in this cluster. Should be an IMAGE that had Vault installed and configured by the install-vault module."
}

variable "consul_cluster_name" {
  description = "What to name the Vault server cluster and all of its associated resources"
  default     = "consul"
}

variable "consul_cluster_size" {
  description = "The number of Vault server nodes to deploy. We strongly recommend using 3 or 5."
  default     = 3
}

variable "use_default_vpc" {
  description = "Whether to use the default VPC - NOT recommended for production! - should more likely change this to false and use the vpc_tags to find your vpc"
  default     = true
}
