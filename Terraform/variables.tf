# main-vars.tf
############################################
# Compartments
############################################

variable "compartment_id" {
  description = "The OCID of the parent compartment where the resources will be created."
  type        = string
}

variable "compartment_name" {
  description = "Compartment Name"
  type        = string
  default     = "cloudquicklabs-compartment"
}

variable "compartment_description" {
  description = "Compartment Description"
  type        = string
  default     = "test-compartment description"
}

############################################
# VCN
############################################

variable "vcn1" {
  description = "The details of VCN1."
  default = {
    cidr_blocks : ["10.23.0.0/20"]
    display_name : "vcn01"
  }
}

############################################
# Public Subnet, Route Table, and Internet Gateway
############################################

variable "subnetA_pub" {
  description = "The details of the subnet"
  default = {
    cidr_block : "10.23.11.0/24"
    display_name : "IC_pub_snet-A"
    is_public : true
    route_table : {
      display_name = "routeTable-Apub"
      description  = "routeTable-Apub"
    }
  }
}

variable "internet_gateway_A" {
  description = "The details of the internet gateway"
  default = {
    display_name : "IC_IG-A"
    ig_destination = "0.0.0.0/0"
  }
}

############################################
# Compute Instance
############################################

variable "ic_pub_vm_A" {
  description = "The details of the compute instance"
  default = {
    display_name : "IC_pub_vm-A"
    assign_public_ip : true
    availability_domain : "kMuU:SA-SAOPAULO-1-AD-1"
    image_ocid : "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaaq2isiurhcds2amx6cobtsqi2zf6so4hpgy76v3dnlprn4fclaceq"
    # Nota: VM.Standard.E2.1.Micro devolvio "Out of host capacity" en
    # sa-saopaulo-1 (2 reintentos). Se usa A1.Flex (ARM, Always Free).
    shape : {
      name          = "VM.Standard.A1.Flex"
      ocpus         = 1
      memory_in_gbs = 6
    }
    ssh_authorized_keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCzMcVRtSRzMB9Hn9/MMybkcH7J+hIsgJjesGLEn1wj5a4q0PeOdn8yzmLdvuj7A2uCCi3hxu0tm9G/HqJ8I2gKiS/2iFxqbU1pD6o7WpCfZaWlImdLTlt9BtFZmFQJO6kBx8iTuWv5v6aBEWgnifdWM4GK/igplc8KRN9GyiQQso3EXvWrmlgqJo3SKPIX+PZjSdW92qhPxQq/+ksrhqvvIdYpU3FXBNQSpS6AzMvonPbNLxB30x6Sg1TCtrwozmcPlYLKO20hJO8f3SQD3Loi9vyo/tn0TxQFyyQdHjYyYN8+2emnLue63ANXxDk3x7a5i+x1M65VWNV62dEdUaHI5ARSSaCDGkgnAvrsrc5hh/G1n/nOR6R4rtUudK7BDsJAIQmf1lbhAO4Z3bbbw84sW6ZI3YEJbXGVZeRu8Sc6uCkvtuXF/MshHnTaKu0EuKSAu/6M8eSslFYyJXgdqvuTqNzNAHGaOZtNmRfjOQG/svd5IlUqJw07GmpxTQukGC7EdnTOTffyxkXkPjIZOoQDb7bax2W88lcfXsv6HlFM5RtfINOcrd/6/rqFRZqIl45VYkIV0GQCrpkOxh3egLkBdusrFr32Xp/H6tdJJczkITtVouwWc0mySjgVKH9srChmgYQtPxFNv+hYX2SbwND6xp/pt3hzWUsP5wyo8lW/gw== oci-terraform-key"]
  }
}