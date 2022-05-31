data "oci_core_images" "os" {
  compartment_id           = oci_identity_compartment.football_compartment.id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "20.04"
  shape                    = "VM.Standard.A1.Flex"
  sort_by                  = "TIMECREATED"
  sort_order               = "ASC"
}


module "compute-instance" {
  source  = "oracle-terraform-modules/compute-instance/oci"
  version = "2.4.0-RC1"
  # insert the 15 required variables here

  ad_number = 1
  compartment_ocid = oci_identity_compartment.football_compartment.id
  instance_flex_memory_in_gbs = 24
  instance_flex_ocpus = 4
  source_ocid = data.oci_core_images.os.images[0].id
  ssh_public_keys = file("/home/peter/.ssh/nopass.pub")
  subnet_ocids = [oci_core_subnet.vcn-public-subnet.id]
  instance_display_name = "Oracle Football Betting"
  public_ip = "RESERVED"
  shape = "VM.Standard.A1.Flex"
  user_data = filebase64("../scripts/setup_ansible_user.sh")
}

output "football_ip" {
  value = module.compute-instance.public_ip[0]
}