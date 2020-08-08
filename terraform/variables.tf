variable "project" {
  default = "tyndorael-projects"
}

variable "region" {
  default = "us-east1"
}

variable "zone" {
  default = "us-east1-d"
}

variable "cluster" {
  default = "mobile-apps"
}

variable "node_count" {
  default = 1
}

variable "credentials" {
  default = "~/.ssh/tyndorael_projects_mobile_apps_cluster_gcp_creds.json"
}

variable "kubernetes_min_ver" {
  default = "latest"
}

variable "kubernetes_max_ver" {
  default = "latest"
}

variable "machine_type" {
  default = "g1-small"
}

variable "app_name" {
  default = "cicd-101"
}