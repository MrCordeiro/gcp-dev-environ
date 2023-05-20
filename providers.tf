terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.35.0"
    }
  }
}

provider "google" {
  project = var.project_id
}

locals {
  # Enable services (APIs)
  # Just list them here so that the below resource creates them
  gcp_service_list = [
    "compute.googleapis.com",
  ]
}

resource "google_project_service" "this" {
  for_each = toset(local.gcp_service_list)
  project  = var.project_id

  service = each.key
  # We want to get an error if we disable an API that a service needs and keep it,
  # even if it's removed from config
  disable_dependent_services = false
  disable_on_destroy         = false
}