variable "project_id" {
  description = "The ID of the project where resources will be created"
  type        = string
}

variable "public_key_path" {
  description = "Path to the host public key to be used for SSH access to the instance"
  type        = string
  default     = "~/.ssh/id_gcp_dev_environ.pub"
}

variable "host_ip" {
  description = "IP of the host which will have access to the instances in CIDR notation"
  type        = string
}

variable "host_os" {
  description = "OS of the host machine. Options are: linux | windows"
  type        = string
  default     = "linux"
}

variable "region" {
  description = "Region where the resources will be created"
  type        = string
  default     = "europe-west1"
}
