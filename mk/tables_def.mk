TABLES =

# IPv4 networks / special destinations
# ========================================================================

TABLES += inet_rfc1918
TABLE_OPTS_inet_rfc1918 = -4
TABLE_INPUT_inet_rfc1918 += @inet/priv


# IPv6 networks / special destinations
# ========================================================================

TABLES += inet6_all_nodes
TABLE_OPTS_inet6_all_nodes = -6
TABLE_INPUT_FILES_inet6_all_nodes = ${SRC}/inet6_all_nodes

TABLES += inet6_all_routers
TABLE_OPTS_inet6_all_routers = -6
TABLE_INPUT_FILES_inet6_all_routers = ${SRC}/inet6_all_routers

TABLES += inet6_all_dhcp_servers
TABLE_OPTS_inet6_all_dhcp_servers = -6
TABLE_INPUT_FILES_inet6_all_dhcp_servers = ${SRC}/inet6_all_dhcp_servers

TABLES += inet6_ndp
TABLE_OPTS_inet6_ndp = -6
TABLE_INPUT_FILES_inet6_ndp = ${SRC}/inet6_ndp

TABLES += inet6_link_local
TABLE_OPTS_inet6_link_local = -6
TABLE_INPUT_inet6_link_local = @inet6/link-local

TABLES += inet6_ula
TABLE_OPTS_inet6_ula = -6
TABLE_INPUT_inet6_ula = @inet6/ula

TABLES += inet6_dst_gw
TABLE_OPTS_inet6_dst_gw = -6
TABLE_INPUT_FILES_inet6_dst_gw =
TABLE_INPUT_FILES_inet6_dst_gw += ${O_TABLES}/inet6_link_local
TABLE_INPUT_FILES_inet6_dst_gw += ${O_TABLES}/inet6_all_nodes
TABLE_INPUT_FILES_inet6_dst_gw += ${O_TABLES}/inet6_all_routers
TABLE_INPUT_FILES_inet6_dst_gw += ${O_TABLES}/inet6_ndp


# private IPv4 / IPv6 space
# ========================================================================

TABLES += private
TABLE_INPUT_FILES_private = ${O_TABLES}/inet_rfc1918 ${O_TABLES}/inet6_ula


# public IPv4 / IPv6 space
# ========================================================================
#
# computed from subtracting known non-public networks from 0/0 / ::/0

TABLES += wan_public4
TABLE_INPUT_wan_public4 = @inet/martians
TABLE_OPTS_wan_public4 = -4
TABLE_INPUT_OPTS_wan_public4 = -i

TABLES += wan_public6
TABLE_INPUT_wan_public6 = @inet6/martians
TABLE_OPTS_wan_public6 = -6
TABLE_INPUT_OPTS_wan_public6 = -i

TABLES += wan_public
TABLE_INPUT_FILES_wan_public = ${O_TABLES}/wan_public4 ${O_TABLES}/wan_public6


# IPv4 / IPv6 networks that should not appear on wan links
# ========================================================================
#
# TODO/fix-maybe: includes multicast

TABLES += wan_martians4
TABLE_OPTS_wan_martians4 = -4
TABLE_INPUT_FILES_wan_martians4 = ${O_TABLES}/wan_public4
TABLE_INPUT_OPTS_wan_martians4 = -i

TABLES += wan_martians6
TABLE_OPTS_wan_martians6 = -6
TABLE_INPUT_FILES_wan_martians6 = ${O_TABLES}/wan_public6
TABLE_INPUT_OPTS_wan_martians6 = -i
TABLE_PURGE_wan_martians6 += @inet6/link-local

TABLES += wan_martians
TABLE_INPUT_FILES_wan_martians = ${O_TABLES}/wan_martians4 ${O_TABLES}/wan_martians6
