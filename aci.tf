terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
    }
  }
}

provider "aci" {
  # cisco-aci user name
  username = "admin"
  # cisco-aci password
  password = "NotMyPassword"
  # cisco-aci url
  url      = "https://172.31.16.5"
  insecure = true
}

# resource "aci_local_user" "admin" {
#   name = "admin"
#   pwd = "NotMyPassword"
#   account_status = "active"
#   expiration = "never"
#   clear_pwd_history = "yes"
# }

# resource "aci_local_user" "justin_oeder" {
#   name = "justin.oeder"
#   pwd = "NotMyPassword"
#   account_status = "active"
#   expiration = "never"
#   first_name = "Justin"
#   last_name = "Oeder"
#   phone = "555-554-5555"
#   email = "aol@aol.com"
#   clear_pwd_history = "yes"
# }

resource "aci_fabric_node_member" "SPINE_901" {
  name = "SPINE_901"
  serial  = "TEP-1-103"
  name_alias  = "SPINE_901"
  node_id  = "901"
  pod_id  = "1"
  role  = "spine"
}

resource "aci_fabric_node_member" "LEAF_101" {
  name = "LEAF_101"
  serial  = "TEP-1-101"
  name_alias  = "LEAF_101"
  node_id  = "101"
  pod_id  = "1"
  role  = "leaf"
}

resource "aci_fabric_node_member" "LEAF_102" {
  name = "LEAF_102"
  serial  = "TEP-1-102"
  name_alias  = "LEAF_102"
  node_id  = "102"
  pod_id  = "1"
  role  = "leaf"
}

resource "aci_vlan_pool" "ALL_VLANS_POOL" {
    alloc_mode  = "static"
    description = "ALL_VLANS_POOL"
    name        = "ALL_VLANS_POOL"
    name_alias  = "ALL_VLANS_POOL"
}

resource "aci_ranges" "ALL_VLANS_RANGE" {
  # VLAN Pool Range
  vlan_pool_dn = aci_vlan_pool.ALL_VLANS_POOL.id
  description = "ALL_VLANS_RANGE"
  from = "vlan-1"
  to = "vlan-4094"
  alloc_mode = "static"
  name_alias = "ALL_VLANS_RANGE"
  role = "external"
}

resource "aci_physical_domain" "LAB_PHYS_DOM" {
  name  = "LAB_PHYS_DOM"
  name_alias  = "LAB_PHYS_DOM"
  relation_infra_rs_vlan_ns = aci_vlan_pool.ALL_VLANS_POOL.id
}

resource "aci_lldp_interface_policy" "LLDP_ENABLED_INT_POL" {
  name = "LLDP_ENABLED_INT_POL"
  description = "LLDP_ENABLED_INT_POL"
  admin_rx_st = "enabled"
  admin_tx_st = "enabled" 
}

resource "aci_cdp_interface_policy" "CDP_ENABLED_INT_POL" {
  name = "CDP_ENABLED_INT_POL"
  description = "CDP_ENABLED_INT_POL"
  admin_st = "enabled"
}

resource "aci_miscabling_protocol_interface_policy" "MCP_ENABLED_INT_POL" {
  name = "MCP_ENABLED_INT_POL"
  description = "MCP_ENABLED_INT_POL"
  admin_st = "enabled"
}

resource "aci_leaf_access_port_policy_group" "LEAF_ACCESS_PORT_GRP_POL" {
  name = "LEAF_ACCESS_PORT_GRP_POL"
  description = "LEAF_ACCESS_PORT_GRP_POL"
  relation_infra_rs_lldp_if_pol = aci_lldp_interface_policy.LLDP_ENABLED_INT_POL.id
  relation_infra_rs_cdp_if_pol = aci_cdp_interface_policy.CDP_ENABLED_INT_POL.id
  relation_infra_rs_mcp_if_pol = aci_miscabling_protocol_interface_policy.MCP_ENABLED_INT_POL.id
}

resource "aci_lacp_policy" "LEAF_ACCESS_LACP_ACTIVE_INT_POL" {
  name = "LEAF_ACCESS_LACP_ACTIVE_INT_POLL"
  description = "LEAF_ACCESS_LACP_ACTIVE_INT_POL"
  mode = "active"
}

resource "aci_lacp_policy" "LEAF_ACCESS_LACP_PASSIVE_INT_POL" {
  name = "LEAF_ACCESS_LACP_PASSIVE_INT_POLL"
  description = "LEAF_ACCESS_LACP_PASSIVE_INT_POL"
  mode = "passive"
}

resource "aci_leaf_access_bundle_policy_group" "LEAF_PORT_CHANNEL_INT_POL" {
  name = "LEAF_PORT_CHANNEL_INT_POL"
  name_alias = "LEAF_PORT_CHANNEL_INT_POL"
  lag_t = "link"
}

resource "aci_attachable_access_entity_profile" "ALL_VLANS_AEP" {
  name = "ALL_VLANS_AEP"
  name_alias = "ALL_VLANS_AEP"
  relation_infra_rs_dom_p = [ aci_physical_domain.LAB_PHYS_DOM.id ]
}

resource "aci_tenant" "HOME_LAB_TENANT" {
  name        = "HOME_LAB_TENANT"
  description = "Home Lab Tenant Created by Terraform"
}

resource "aci_vrf" "HOME_LAB_VRF" {
  tenant_dn              = aci_tenant.HOME_LAB_TENANT.id
  name                   = "HOME_LAB_VRF"
  description            = "HOME_LAB_VRF"
  annotation             = "HOME_LAB_VRF"
  bd_enforced_enable     = "no"
  ip_data_plane_learning = "enabled"
  knw_mcast_act          = "permit"
  name_alias             = "HOME_LAB_VRF"
  pc_enf_dir             = "egress"
  pc_enf_pref            = "unenforced"
}

resource "aci_any" "HOME_LAB_VRF_PREF_GROUP" {
  vrf_dn = aci_vrf.HOME_LAB_VRF.id
  pref_gr_memb = "enabled"
}

resource "aci_application_profile" "PROD_AP" {
  name = "PROD_AP"
  name_alias = "PROD_AP"
  tenant_dn = aci_tenant.HOME_LAB_TENANT.id
}

resource "aci_bridge_domain" "VLAN_10_BD" {
  tenant_dn = aci_tenant.HOME_LAB_TENANT.id
  description = "VLAN_10_BD"
  name = "VLAN_10_BD"
  name_alias = "VLAN_10_BD"
  relation_fv_rs_ctx = aci_vrf.HOME_LAB_VRF.id
}

resource "aci_application_epg" "VLAN_10_EPG" {
  application_profile_dn = aci_application_profile.PROD_AP.id
  name = "VLAN_10_EPG"
  description = "VLAN_10_EPG"
  name_alias = "VLAN_10_EPG"
  pref_gr_memb = "include"
  relation_fv_rs_bd = aci_bridge_domain.VLAN_10_BD.id
}

resource "aci_epg_to_domain" "VLAN_10_EPG_LAB_PHYS_DOM" {
  application_epg_dn = aci_application_epg.VLAN_10_EPG.id
  tdn = aci_physical_domain.LAB_PHYS_DOM.id  
}

resource "aci_bridge_domain" "VLAN_20_BD" {
  tenant_dn = aci_tenant.HOME_LAB_TENANT.id
  description = "VLAN_20_BD"
  name = "VLAN_20_BD"
  name_alias = "VLAN_20_BD"
  relation_fv_rs_ctx = aci_vrf.HOME_LAB_VRF.id
}

resource "aci_application_epg" "VLAN_20_EPG" {
  application_profile_dn = aci_application_profile.PROD_AP.id
  name = "VLAN_20_EPG"
  description = "VLAN_20_EPG"
  name_alias = "VLAN_20_EPG"
  pref_gr_memb = "include"
  relation_fv_rs_bd = aci_bridge_domain.VLAN_20_BD.id
}

resource "aci_epg_to_domain" "VLAN_20_EPG_LAB_PHYS_DOM" {
  application_epg_dn = aci_application_epg.VLAN_20_EPG.id
  tdn = aci_physical_domain.LAB_PHYS_DOM.id  
}
