resource "vsphere_virtual_machine" "ubuntu_vm" {
  name             = var.vm_name
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.vm_cpu
  memory   = var.vm_memory
  guest_id = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = "vmxnet3"
  }

  network_interface {
    network_id   = data.vsphere_network.internal_network.id
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "disk0"
    size             = var.vm_disk_size
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = var.vm_name
        domain    = "local"
      }

      network_interface {
        ipv4_address = var.vm_static_ip
        ipv4_netmask = 24
      }

      network_interface {
        ipv4_address = "10.200.16.101"
        ipv4_netmask = 29
      }

      ipv4_gateway = "10.200.16.1"
    }
  }
}
