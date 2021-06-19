# fill up table config vars
# ========================================================================
.for table_name in ${TABLES}

# basic table definition
# ------------------------------------------------------------------------

# The build rules require at least one input/purge file,
# use an empty one as fallback
TABLE_INPUT_FILES_${table_name}   ?= ${_EMPTY_SRC}
TABLE_PURGE_FILES_${table_name}   ?= ${_EMPTY_SRC}
TABLE_INPUT_${table_name}         ?=
TABLE_PURGE_${table_name}         ?=
TABLE_OPTS_${table_name}          ?=
TABLE_INPUT_OPTS_${table_name}    ?=
TABLE_PURGE_OPTS_${table_name}    ?=

# local additions to input
# ------------------------------------------------------------------------
TABLE_LOCAL_INPUT_FILES_${table_name} != { test -f ${LOCAL_SRC}/${table_name} && printf '%s\n' ${LOCAL_SRC}/${table_name} || :; }

TABLE_INPUT_FILES_${table_name} += ${TABLE_LOCAL_INPUT_FILES_${table_name}}


# local additions to purge
# ------------------------------------------------------------------------
TABLE_LOCAL_PURGE_FILES_${table_name} != { test -f ${LOCAL_SRC}/purge-${table_name} && printf '%s\n' ${LOCAL_SRC}/purge-${table_name} || :; }

TABLE_PURGE_FILES_${table_name} += ${TABLE_LOCAL_PURGE_FILES_${table_name}}

.endfor

# Basic Rules
# ========================================================================

# common prereq for install-*
PHONY += install-tables-dir
install-tables-dir:
	${DODIR} ${DESTDIR}${TABLES_INSTALL_DIR}

# list of tables (copy-paste template for pf.conf)
PHONY += tables-list
BUILD_TARGETS += tables-list
tables-list: ${O_TABLES}/list

${O_TABLES}/list: FORCE
	${MKDIRP} ${@D}
	{ set -efu; \
		printf '%s\n' ${TABLES} \
			| sort \
			| xargs -I '{name}' \
				printf 'table <%s> const file "%s"\n' \
					'{name}' '${TABLES_INSTALL_DIR}/{name}'; \
	} > ${@}.make_tmp
	${MVF} ${@}.make_tmp ${@}

PHONY += install-tables-list
INSTALL_TARGETS += install-tables-list
install-tables-list: install-tables-dir
	${DOINS} ${O_TABLES}/list ${DESTDIR}${TABLES_INSTALL_DIR}/list


# Rules for generating table files
# ========================================================================
.for table_name in ${TABLES}
# intermediate file for purging networks (ip-dedup "-p" option)
# ------------------------------------------------------------------------
${O_TMP}/purge-${table_name}: ${TABLE_PURGE_FILES_${table_name}}
	${MKDIRP} ${@D}
	${RUN_IP_DEDUP} ${TABLE_OPTS_${table_name}} ${TABLE_PURGE_OPTS_${table_name}} -o ${@}.make_tmp ${.ALLSRC} ${TABLE_PURGE_${table_name}}
	${MVF} ${@}.make_tmp ${@}

# table under construction
# ------------------------------------------------------------------------
TABLE_BUILD_TARGETS += ${O_TABLES}/${table_name}

${O_TABLES}/${table_name}: ${O_TMP}/purge-${table_name} ${TABLE_INPUT_FILES_${table_name}}
	${MKDIRP} ${@D}
	${RUN_IP_DEDUP} ${TABLE_OPTS_${table_name}} ${TABLE_INPUT_OPTS_${table_name}} -o ${@}.make_tmp -p ${.ALLSRC} ${TABLE_INPUT_${table_name}}
	${MVF} ${@}.make_tmp ${@}

# install table
# ------------------------------------------------------------------------

TABLE_INSTALL_TARGETS += install-${table_name}
install-${table_name}: install-tables-dir
	${DOINS} ${O_TABLES}/${table_name} ${DESTDIR}${TABLES_INSTALL_DIR}/${table_name}

.endfor

PHONY += tables
BUILD_TARGETS += tables
tables: ${TABLE_BUILD_TARGETS}

PHONY += ${TABLE_INSTALL_TARGETS}
PHONY += install-tables
INSTALL_TARGETS += install-tables
install-tables: ${TABLE_INSTALL_TARGETS}
