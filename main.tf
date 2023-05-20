module "network" {
  source          = "./modules/network"
  network_name    = "dev-network"
  subnetwork_name = "dev-subnetwork"
  subnet_cidr     = "10.142.0.0/20"
  region          = var.region
  project         = var.project_id
  firewall_name   = "dev-firewall"
  router_name     = "dev-router"
  nat_name        = "dev-nat"
  host_ip         = var.host_ip
}

resource "google_compute_instance" "workspace" {
  name         = "dev-workspace"
  machine_type = "f1-micro"
  zone         = "${var.region}-b"
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = data.google_compute_image.os_image.self_link
    }
  }

  network_interface {
    subnetwork = module.network.subnet.name
    access_config {
      // Leave this empty to use an ephemeral IP.
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  metadata_startup_script = file("templates/userdata.tpl")

  labels = {
    environment = "dev"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

  provisioner "local-exec" {
    command = templatefile("templates/${var.host_os}-ssh-config.tpl", {
      hostname      = self.network_interface[0].access_config[0].nat_ip,
      user          = "ubuntu",
      indentityfile = "~/.ssh/gcp_dev_environ"
    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  }
}