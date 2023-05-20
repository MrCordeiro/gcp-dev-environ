output "instance_public_ip" {
  description = "The public IP of the instance"
  value       = google_compute_instance.workspace.network_interface[0].access_config[0].nat_ip
}
