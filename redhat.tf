# =========================================================
# REDHAT SOURCE VM
# =========================================================
data "vsphere_virtual_machine" "redhat_template" {
  name          = "redhat"
  datacenter_id = data.vsphere_datacenter.dc.id
}
# =========================================================
# LAMP VM
# =========================================================
resource "vsphere_virtual_machine" "lamp01" {
  name             = "lamp01-vm"
  host_system_id   = data.vsphere_host.esxi02.id
  datastore_id     = data.vsphere_datastore.datastore_esxi02.id
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id

  # CPU / Memory
  num_cpus = 1
  memory   = 1024

  # Source VM uses EFI
  firmware = "efi"

  # Same OS type as source
  guest_id = data.vsphere_virtual_machine.redhat_template.guest_id

  # =======================================================
  # NETWORK 1
  # =======================================================

  network_interface {
    network_id   = data.vsphere_network.network1.id
    adapter_type = "vmxnet3"
  }

  # =======================================================
  # NETWORK 2
  # =======================================================

  network_interface {
    network_id   = data.vsphere_network.network2.id
    adapter_type = "vmxnet3"
  }

  # =======================================================
  # SOURCE DISK
  # =======================================================

  disk {
    label            = "disk0"
    size             = 16
    thin_provisioned = false
  }

  # =======================================================
  # CLONE
  # =======================================================

  clone {
    template_uuid = data.vsphere_virtual_machine.redhat_template.id
  }
}
# =========================================================
# web VM
# ESXi01
# Datastore: esxi01-datastore1
# Created AFTER lamp01
# =========================================================

resource "vsphere_virtual_machine" "web01" {

  name = "web01-vm"

  # Explicit ESXi01 host
  host_system_id = data.vsphere_host.esxi01.id

  # ESXi01 datastore
  datastore_id = data.vsphere_datastore.datastore_esxi01.id

  # Resource pool
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id

  num_cpus = 1
  memory   = 1024

  # Source VM uses EFI
  firmware = "efi"

  # Same OS type as source
  guest_id = data.vsphere_virtual_machine.redhat_template.guest_id

  # =======================================================
  # NETWORK 1
  # =======================================================

  network_interface {
    network_id   = data.vsphere_network.network1.id
    adapter_type = "vmxnet3"
  }

  # =======================================================
  # NETWORK 2
  # =======================================================

  network_interface {
    network_id   = data.vsphere_network.network2.id
    adapter_type = "vmxnet3"
  }

  # =======================================================
  # SOURCE DISK
  # =======================================================

  disk {
    label            = "disk0"
    size             = 16
    thin_provisioned = false
  }

  # =======================================================
  # CLONE
  # =======================================================

  clone {
    template_uuid = data.vsphere_virtual_machine.redhat_template.id
  }

  # =======================================================
  # CREATE WEB01 ONLY AFTER LAMP01
  # =======================================================
  depends_on = [
    vsphere_virtual_machine.lamp01
  ]
}

# =========================================================
# DB VM
# ESXi01
# Datastore: esxi01-datastore1
# Created AFTER ans01
# =========================================================

resource "vsphere_virtual_machine" "db01" {

  name = "db01-vm"
  # Explicit ESXi01 host
  host_system_id = data.vsphere_host.esxi01.id

  # ESXi01 datastore
  datastore_id = data.vsphere_datastore.datastore_esxi01.id

  # Resource pool
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id

  num_cpus = 1
  memory   = 1024

  # Source VM uses EFI
  firmware = "efi"

  # Same OS type as source
  guest_id = data.vsphere_virtual_machine.redhat_template.guest_id

  # =======================================================
  # NETWORK 1
  # =======================================================

  network_interface {
    network_id   = data.vsphere_network.network1.id
    adapter_type = "vmxnet3"
  }

  # =======================================================
  # NETWORK 2
  # =======================================================

  network_interface {
    network_id   = data.vsphere_network.network2.id
    adapter_type = "vmxnet3"
  }

  # =======================================================
  # SOURCE DISK
  # =======================================================

  disk {
    label            = "disk0"
    size             = 16
    thin_provisioned = false
  }

  # =======================================================
  # CLONE
  # =======================================================

  clone {
    template_uuid = data.vsphere_virtual_machine.redhat_template.id
  }

  # =======================================================
  # CREATE DB01 ONLY AFTER WEB01
  # =======================================================
  depends_on = [
    vsphere_virtual_machine.web01
  ]
} 