S        := ${.CURDIR}
O        :=
O_TMP    := tmp
O_TABLES := tables

MK := ${S}/mk
LOCALDIR = ${S}/local

SRC = ${S}/src
LOCAL_SRC = ${LOCALDIR}/src

PHONY =

BUILD_TARGETS =
INSTALL_TARGETS =

PHONY += all
all: tables

PHONY += clean
clean:
	[ ! -d '${O_TMP}' ] || { find ${O_TMP} -maxdepth 1 -type f -delete && rmdir ${O_TMP}; }
	[ ! -d '${O_TABLES}' ] || { find '${O_TABLES}' -maxdepth 1 -type f -delete && rmdir ${O_TABLES}; }

.include "${MK}/prj.mk"
.include "${MK}/install_vars.mk"
.include "${MK}/vars.mk"
.include "${MK}/tables_def.mk"
-include "${LOCALDIR}/tables_def.mk"
.include "${MK}/tables_rules.mk"


PHONY += build
build: ${BUILD_TARGETS}

PHONY += install
install: ${INSTALL_TARGETS}


FORCE:

.PHONY: ${PHONY}
