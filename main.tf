data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network_external" {
  name          = var.vsphere_network_external
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network_internal" {
  name          = var.vsphere_network_internal
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.vm_name
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 4096
  guest_id = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id   = data.vsphere_network.network_external.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  network_interface {
    network_id   = data.vsphere_network.network_internal.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
    vlan {
      id = 150
    }
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
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
        ipv4_address = var.external_ip
        ipv4_netmask = 24
      }

      network_interface {
        ipv4_address = "10.200.16.101"
        ipv4_netmask = 29
      }

      ipv4_gateway = "your-external-gateway-ip"
    }
  }
}

output "vm_id" {
  value = vsphere_virtual_machine.vm.id
}
