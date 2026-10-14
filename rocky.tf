# =========================================================
# ROCKY SOURCE VM
# =========================================================
data "vsphere_virtual_machine" "rocky_template" {
  name          = "rocky-temp"
  datacenter_id = data.vsphere_datacenter.dc.id
}
# =========================================================
# PUPPUT VM
# =========================================================
resource "vsphere_virtual_machine" "pup01" {
  name             = "pup01-vm"
  host_system_id   = data.vsphere_host.esxi02.id
  datastore_id     = data.vsphere_datastore.datastore_esxi02.id
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id

  # CPU / Memory
  num_cpus = 1
  memory   = 1024

  # Source VM uses EFI
  firmware = "efi"

  # Same OS type as source
  guest_id = data.vsphere_virtual_machine.rocky_template.guest_id

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
    template_uuid = data.vsphere_virtual_machine.rocky_template.id
  }
}

# =========================================================
# SONAR QUBE VM
# =========================================================
resource "vsphere_virtual_machine" "son01" {
  name             = "son01-vm"
  host_system_id   = data.vsphere_host.esxi02.id
  datastore_id     = data.vsphere_datastore.datastore_esxi02.id
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id

  # CPU / Memory
  num_cpus = 1
  memory   = 1024

  # Source VM uses EFI
  firmware = "efi"

  # Same OS type as source
  guest_id = data.vsphere_virtual_machine.rocky_template.guest_id

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
    template_uuid = data.vsphere_virtual_machine.rocky_template.id
  }
  # =======================================================
  # CREATE SON01 ONLY AFTER PUP01
  # =======================================================
  depends_on = [
    vsphere_virtual_machine.pup01
  ]
}
# =========================================================
# ZABBIX QUBE VM
# =========================================================
resource "vsphere_virtual_machine" "zap01" {
  name             = "zap01-vm"
  host_system_id   = data.vsphere_host.esxi01.id
  datastore_id     = data.vsphere_datastore.datastore_esxi01.id
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id

  # CPU / Memory
  num_cpus = 1
  memory   = 1024

  # Source VM uses EFI
  firmware = "efi"

  # Same OS type as source
  guest_id = data.vsphere_virtual_machine.rocky_template.guest_id

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
    template_uuid = data.vsphere_virtual_machine.rocky_template.id
  }
  # =======================================================
  # CREATE ZAP01 ONLY AFTER SON01
  # =======================================================
  depends_on = [
    vsphere_virtual_machine.son01
  ]
}
