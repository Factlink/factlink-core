SRC_DIR = src
TEST_DIR = test
BUILD_DIR = build

PREFIX = .
DIST_DIR = ${PREFIX}/dist

BASE_FILES = ${SRC_DIR}/js/core.js\
	${SRC_DIR}/js/conf.js\
	${SRC_DIR}/js/create.js\
	${SRC_DIR}/js/proxy.js\
	${SRC_DIR}/js/replace.js\
	${SRC_DIR}/js/search.js\
	${SRC_DIR}/js/modal.js\
	${SRC_DIR}/js/xdm.js\

MODULES = ${BUILD_DIR}/jquery-1.6.1.js\
	${SRC_DIR}/js/intro.js\
	${BASE_FILES}\
	${SRC_DIR}/js/outro.js

GETFACTS = ${SRC_DIR}/js/getfacts.js
ADDFACTS = ${SRC_DIR}/js/addfacts.js

FL_VER = $(shell cat version.txt)
VER = sed "s/@VERSION/${FL_VER}/"

FACTLINK_TMP = ${DIST_DIR}/factlink-tmp.js
FACTLINK = ${DIST_DIR}/factlink.js
FACTLINK_GETFACTS = ${DIST_DIR}/factlink.getfacts.js
GETFACTS_TMP = ${DIST_DIR}/factlink.getfacts-tmp.js
FACTLINK_ADDFACTS = ${DIST_DIR}/factlink.addfacts.js
ADDFACTS_TMP = ${DIST_DIR}/factlink.addfacts-tmp.js
FACTLINK_MIN = ${DIST_DIR}/factlink.min.js

DATE=$(shell git log -1 --pretty=format:%ad)

all: factlink
	@@echo "Factlink client library build complete"

${DIST_DIR}:
	@@mkdir -p ${DIST_DIR}

factlink: ${FACTLINK} ${FACTLINK_GETFACTS} ${FACTLINK_ADDFACTS}

${FACTLINK}: ${MODULES} | ${DIST_DIR}
	@@echo "Building" ${Factlink}

	@@cat ${MODULES} | \
		sed 's/.function..Factlink...{//' | \
		sed 's/}...window\.Factlink..;//' | \
		sed 's/@DATE/'"${DATE}"'/' | \
		${VER} > ${FACTLINK_TMP};

	node Makefile.js factlink ${FACTLINK_TMP}

	@@rm ${FACTLINK_TMP}

${FACTLINK_GETFACTS}: ${GETFACTS}
	@@echo "Building" ${FACTLINK_GETFACTS}

	@@cat ${GETFACTS} > ${GETFACTS_TMP}

	node Makefile.js factlink.getfacts ${GETFACTS_TMP}

	@@rm ${GETFACTS_TMP}

${FACTLINK_ADDFACTS}: ${ADDFACTS}
	@@echo "Building" ${FACTLINK_ADDFACTS}

	@@cat ${ADDFACTS} > ${ADDFACTS_TMP}

	node Makefile.js factlink.addfacts ${ADDFACTS_TMP}

	@@rm ${ADDFACTS_TMP}

min: factlink ${FACTLINK_MIN}
	@@echo "Minifying core"

clean:
	@@echo "Removing Distribution directory:" ${DIST_DIR}
	@@rm -rf ${DIST_DIR}

test:
	@@echo "Running tests using smoosh:"
	node make/test.js

.PHONY: all factlink min clean test