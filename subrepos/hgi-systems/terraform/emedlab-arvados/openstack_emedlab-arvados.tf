provider "openstack" {
  alias = "emedlab-arvados"
  tenant_name = "arvados"
}

resource "openstack_compute_keypair_v2" "mercury_emedlab-arvados" {
  provider = "openstack.emedlab-arvados"
  name = "mercury_emedlab-arvados"
  public_key = "${var.mercury_keypair}"
}

resource "openstack_compute_keypair_v2" "jr17_emedlab-arvados" {
  provider = "openstack.emedlab-arvados"
  name = "jr17_emedlab-arvados"
  public_key = "${var.jr17_keypair}"
}

resource "openstack_compute_secgroup_v2" "ssh_emedlab-arvados" {
  provider = "openstack.emedlab-arvados"
  name = "ssh_emedlab-arvados"
  description = "Incoming ssh access"
  rule {
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
}

resource "openstack_networking_network_v2" "main_emedlab-arvados" {
  provider = "openstack.emedlab-arvados"
  name = "main_emedlab-arvados"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "main_emedlab-arvados" {
  provider = "openstack.emedlab-arvados"
  name = "main_emedlab-arvados"
  network_id = "${openstack_networking_network_v2.main_emedlab-arvados.id}"
  cidr = "10.101.0.0/24"
  ip_version = 4
}

resource "openstack_networking_router_v2" "main_arvados-net_emedlab-arvados" {
  provider = "openstack.emedlab-arvados"
  name = "main_arvados-net_emedlab-arvados"
  external_gateway = "74af2c0a-46c6-4f69-8d17-819a721b4b5c"
}

resource "openstack_networking_router_interface_v2" "main_arvados-net_emedlab-arvados" {
  provider = "openstack.emedlab-arvados"
  router_id = "${openstack_networking_router_v2.main_arvados-net_emedlab-arvados.id}"
  subnet_id = "${openstack_networking_subnet_v2.main_emedlab-arvados.id}"
}
