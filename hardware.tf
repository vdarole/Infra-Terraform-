# =========================================================
# DATACENTER
# =========================================================

data "vsphere_datacenter" "dc" {
  name = "darole-dc"
}


# =========================================================
# ESXi HOSTS
# =========================================================

data "vsphere_host" "esxi01" {
  name          = "esxi01.darole.org"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "esxi02" {
  name          = "esxi02.darole.org"
  datacenter_id = data.vsphere_datacenter.dc.id
}


# =========================================================
# DATASTORES
# =========================================================

data "vsphere_datastore" "datastore_esxi01" {
  name          = "esxi01-datastore1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore_esxi02" {
  name          = "esxi02-datastore1"
  datacenter_id = data.vsphere_datacenter.dc.id
}


# =========================================================
# COMPUTE CLUSTER
# =========================================================

data "vsphere_compute_cluster" "cluster" {
  name          = "my-cluster"
  datacenter_id = data.vsphere_datacenter.dc.id
}


# =========================================================
# NETWORK 1
# =========================================================

data "vsphere_network" "network1" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}


# =========================================================
# NETWORK 2
# =========================================================

data "vsphere_network" "network2" {
  name          = "VM Network 2"
  datacenter_id = data.vsphere_datacenter.dc.id
}