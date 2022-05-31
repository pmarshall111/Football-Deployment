resource "oci_identity_compartment" "football_compartment" {
  compartment_id = var.tenancy_ocid
  description = "Compartment for Terraform resources."
  name = "football_betting"
}