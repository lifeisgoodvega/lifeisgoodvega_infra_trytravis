variable cloud_id {
  description = "Cloud"
}
variable folder_id {
  description = "Folder"
}
variable zone {
  description = "Zone"
  default     = "ru-central1-b"
}
variable instance_zone {
  description = "Zone of VM instance"
  default     = "ru-central1-b"
}
variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable private_key_path {
  description = "Path to the private key used for ssh access"
}
variable image_id {
  description = "Disk image"
}
variable subnet_id {
  description = "Subnet"
}
variable instances_count {
  description = "How much of instances will work under load balancer"
  default     = 1
}
variable service_account_key_file {
  description = "key .json"
}
variable reddit_listener_port {
  description = "reddit listener port"
  default     = 9292
}
