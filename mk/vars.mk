IP_DEDUP = ip-dedup
IP_DEDUP_OPTS =

IP_DEDUP_FETCH_ASN = ip-dedup-asn
IP_DEDUP_FETCH_ASN_OPTS =

RUN_IP_DEDUP = ${IP_DEDUP} ${IP_DEDUP_OPTS}
RUN_IP_DEDUP_FETCH_ASN = ${IP_DEDUP_FETCH_ASN} ${IP_DEDUP_FETCH_ASN_OPTS}

TABLES_INSTALL_DIR = ${SHAREDIR}/${PN}


MV = mv
MVF = ${MV} -f --
