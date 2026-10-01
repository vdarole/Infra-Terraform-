# =========================================================
# UBUNTU TEMPLATE
# =========================================================

data "vsphere_virtual_machine" "ubuntu_template" {
  name          = "ubuntu"
  datacenter_id = data.vsphere_datacenter.dc.id
}
# =========================================================
# ANSIBLE VM
# ESXi02
# Datastore: esxi02-datastore1
# =========================================================

resource "vsphere_virtual_machine" "ans01" {

  name = "ans01-vm"

  # Explicit ESXi02 host
  host_system_id = data.vsphere_host.esxi02.id

  # ESXi02 datastore
  datastore_id = data.vsphere_datastore.datastore_esxi02.id

  # Resource pool
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id

  # CPU / Memory
  num_cpus = 1
  memory   = 2048

  # Ubuntu guest
  guest_id = data.vsphere_virtual_machine.ubuntu_template.guest_id


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
  # DISK
  # =======================================================

  disk {
    label            = "disk0"
    size             = 16
    thin_provisioned = true
  }


  # =======================================================
  # CLONE FROM UBUNTU TEMPLATE
  # =======================================================

  clone {
    template_uuid = data.vsphere_virtual_machine.ubuntu_template.id
  }
}


# =========================================================
# DOCKER VM
# ESXi01
# Datastore: esxi01-datastore1
# Created AFTER ans01
# =========================================================

resource "vsphere_virtual_machine" "dock01" {

  name = "dock01-vm"

  # Explicit ESXi01 host
  host_system_id = data.vsphere_host.esxi01.id

  # ESXi01 datastore
  datastore_id = data.vsphere_datastore.datastore_esxi01.id

  # Resource pool
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id

  # CPU / Memory
  num_cpus = 1
  memory   = 1024

  # Ubuntu guest
  guest_id = data.vsphere_virtual_machine.ubuntu_template.guest_id


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
  # DISK
  # =======================================================

  disk {
    label            = "disk0"
    size             = 16
    thin_provisioned = true
  }


  # =======================================================
  # CLONE FROM UBUNTU TEMPLATE
  # =======================================================

  clone {
    template_uuid = data.vsphere_virtual_machine.ubuntu_template.id
  }


  # =======================================================
  # CREATE DOCK01 ONLY AFTER ANS01
  # =======================================================

  depends_on = [
    vsphere_virtual_machine.ans01
  ]
}

# =========================================================
# TOMCAT DEVELOPMENT VM
# ESXi02
# Datastore: esxi02-datastore1
# Created AFTER dock01
# =========================================================

resource "vsphere_virtual_machine" "tomd01" {

  name = "tomd01-vm"

  # Explicit ESXi02 host
  host_system_id = data.vsphere_host.esxi02.id

  # ESXi02 datastore
  datastore_id = data.vsphere_datastore.datastore_esxi02.id

  # Resource pool
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id


  # CPU / Memory
  num_cpus = 1
  memory   = 1024

  # Ubuntu guest
  guest_id = data.vsphere_virtual_machine.ubuntu_template.guest_id


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
  # DISK
  # =======================================================

  disk {
    label            = "disk0"
    size             = 16
    thin_provisioned = true
  }


  # =======================================================
  # CLONE FROM UBUNTU TEMPLATE
  # =======================================================

  clone {
    template_uuid = data.vsphere_virtual_machine.ubuntu_template.id
  }


  # =======================================================
  # CREATE tomd01 ONLY AFTER dock01
  # =======================================================

  depends_on = [
    vsphere_virtual_machine.dock01
  ]
}

# =========================================================
# TOMCAT PRODUCTION VM
# ESXi01
# Datastore: esxi01-datastore1
# Created AFTER tomd01
# =========================================================

resource "vsphere_virtual_machine" "tomp01" {

  name = "tomp01-vm"

  # Explicit ESXi01 host
  host_system_id = data.vsphere_host.esxi01.id

  # ESXi02 datastore
  datastore_id = data.vsphere_datastore.datastore_esxi01.id

  # Resource pool
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id


  # CPU / Memory
  num_cpus = 1
  memory   = 1024

  # Ubuntu guest
  guest_id = data.vsphere_virtual_machine.ubuntu_template.guest_id


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
  # DISK
  # =======================================================

  disk {
    label            = "disk0"
    size             = 16
    thin_provisioned = true
  }


  # =======================================================
  # CLONE FROM UBUNTU TEMPLATE
  # =======================================================

  clone {
    template_uuid = data.vsphere_virtual_machine.ubuntu_template.id
  }


  # =======================================================
  # CREATE tomp01 ONLY AFTER tomd01
  # =======================================================

  depends_on = [
    vsphere_virtual_machine.tomd01
  ]
}