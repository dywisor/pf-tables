.for _geo in ${TABLE_DL_geo_suspect}
TABLE_INPUT_FILES_geo_suspect += ${O_DL}/geo-${_geo}

${O_DL}/geo-${_geo}: ${DEP_DL}
	${MKDIRP} ${O_DL}
	${X_DOWNLOAD} -o ${@}.in.make_tmp \
		'http://ipdeny.com/ipblocks/data/countries/${_geo}.zone'
	${RUN_IP_DEDUP} -k -o ${@}.make_tmp ${@}.in.make_tmp
	test -s ${@}.make_tmp
	rm -f -- ${@}.in.make_tmp
	mv -f -- ${@}.make_tmp ${@}
.endfor
