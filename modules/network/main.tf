resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
  project                 = var.project
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnetwork_name
  ip_cidr_range = var.subnet_cidr
  network       = google_compute_network.vpc_network.self_link
  region        = var.region
  project       = var.project
}

resource "google_compute_router" "router" {
  name    = var.router_name
  region  = var.region
  network = google_compute_network.vpc_network.name
  project = var.project
}

resource "google_compute_router_nat" "nat" {
  name   = var.nat_name
  router = google_compute_router.router.name
  region = google_compute_router.router.region
  project = var.project

  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_firewall" "firewall" {
  name    = var.firewall_name
  network = google_compute_network.vpc_network.name
  project = var.project

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = [trim(var.host_ip, " ")]
}
