provider "openstack" {
  alias = "delta-hgi"
  tenant_name = "${var.env == "production" ? "hgi" : "hgi-dev"}"
}

resource "openstack_compute_keypair_v2" "mercury_delta-hgi" {
  provider = "openstack.delta-hgi"
  name = "mercury_delta-hgi"
  public_key = "${var.mercury_keypair}"
}

resource "openstack_compute_keypair_v2" "jr17_delta-hgi" {
  provider = "openstack.delta-hgi"
  name = "jr17_delta-hgi"
  public_key = "${var.jr17_keypair}"
}

resource "openstack_compute_secgroup_v2" "ssh_delta-hgi" {
  provider = "openstack.delta-hgi"
  name = "ssh_delta-hgi"
  description = "Incoming ssh access"
  rule {
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
}

resource "openstack_networking_network_v2" "main_delta-hgi" {
  provider = "openstack.delta-hgi"
  name = "main_delta-hgi"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "main_delta-hgi" {
  provider = "openstack.delta-hgi"
  name = "main_delta-hgi"
  network_id = "${openstack_networking_network_v2.main_delta-hgi.id}"
  cidr = "10.101.0.0/24"
  ip_version = 4
}

resource "openstack_networking_router_v2" "main_nova_delta-hgi" {
  provider = "openstack.delta-hgi"
  name = "main_nova_delta-hgi"
  external_gateway = "9f50f282-2a4c-47da-88f8-c77b6655c7db"
}

resource "openstack_networking_router_interface_v2" "main_nova_delta-hgi" {
  provider = "openstack.delta-hgi"
  router_id = "${openstack_networking_router_v2.main_nova_delta-hgi.id}"
  subnet_id = "${openstack_networking_subnet_v2.main_delta-hgi.id}"
}