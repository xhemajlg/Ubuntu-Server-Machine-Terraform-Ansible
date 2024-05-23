variable "vsphere_user" {
  description = "vSphere username"
  type        = string
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
  sensitive   = true
}

variable "vsphere_server" {
  description = "vSphere server address"
  type        = string
}

variable "vsphere_datacenter" {
  description = "vSphere datacenter"
  type        = string
}

variable "vsphere_datastore" {
  description = "vSphere datastore"
  type        = string
}

variable "vsphere_cluster" {
  description = "vSphere cluster"
  type        = string
}

variable "vsphere_network" {
  description = "vSphere network for external interface"
  type        = string
}

variable "vsphere_internal_network" {
  description = "vSphere network for internal interface"
  type        = string
}

variable "vm_name" {
  description = "Name of the VM"
  type        = string
  default     = "ubuntu-server"
}

variable "vm_cpu" {
  description = "Number of CPUs for the VM"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Memory for the VM in MB"
  type        = number
  default     = 2048
}

variable "vm_disk_size" {
  description = "Disk size for the VM in GB"
  type        = number
  default     = 20
}

variable "vm_static_ip" {
  description = "Static IP address for the external interface"
  type        = string
}
