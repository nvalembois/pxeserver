#undef	NET_PROTO_FCOE		/* Fibre Channel over Ethernet protocol */
#undef	NET_PROTO_STP		/* Spanning Tree protocol */
#undef	NET_PROTO_LACP		/* Link Aggregation control protocol */
#undef	NET_PROTO_EAPOL		/* EAP over LAN protocol */
#undef	DOWNLOAD_PROTO_HTTPS	/* Secure Hypertext Transfer Protocol */
#undef IBMGMT_CMD		/* Infiniband management commands */
#undef SANBOOT_CMD		/* SAN boot commands */
#undef NSLOOKUP_CMD		/* DNS resolving command */
#undef DIGEST_CMD		/* Image crypto digest commands */
#undef VLAN_CMD		    /* VLAN commands */
// #define PXE_CMD		/* PXE commands */
#define REBOOT_CMD		/* Reboot command */
#define POWEROFF_CMD	/* Power off command */
#undef IMAGE_TRUST_CMD	/* Image trust management commands */
#undef NEIGHBOUR_CMD	/* Neighbour management commands */
#undef PING_CMD		    /* Ping command */
#undef IPSTAT_CMD		/* IP statistics commands */
#undef NTP_CMD		    /* NTP commands */
#undef CERT_CMD		    /* Certificate management commands */
#undef VNIC_IPOIB		/* Infiniband IPoIB virtual NICs */
