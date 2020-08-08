provider "google" {
  version     = "3.33.0"
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}