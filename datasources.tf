data "google_compute_image" "os_image" {
  family  = "ubuntu-2204-lts"
  project = "ubuntu-os-cloud"
}
