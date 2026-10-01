# =========================================================
# vSPHERE PROVIDER / LOGIN
# =========================================================

provider "vsphere" {
  user                 = "administrator@vsphere.local"
  password             = "Pass@1234"
  vsphere_server       = "vcenter01.darole.org"
  allow_unverified_ssl = true
}