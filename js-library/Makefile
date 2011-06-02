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
	${SRC_DIR}/js/init.js\

MODULES = ${BUILD_DIR}/jquery-1.6.1.js\
	${SRC_DIR}/js/intro.js\
	${BASE_FILES}\
	${SRC_DIR}/js/outro.js

FL_VER = $(shell cat version.txt)
VER = sed "s/@VERSION/${FL_VER}/"

FACTLINK_TMP = ${DIST_DIR}/factlink-tmp.js
FACTLINK = ${DIST_DIR}/factlink.js
FACTLINK_MIN = ${DIST_DIR}/factlink.min.js

DATE=$(shell git log -1 --pretty=format:%ad)

all: factlink
	@@echo "Factlink client library build complete"

${DIST_DIR}:
	@@mkdir -p ${DIST_DIR}

factlink: ${FACTLINK}

${FACTLINK}: ${MODULES} | ${DIST_DIR}
	@@echo "Building" ${Factlink}

	@@cat ${MODULES} | \
		sed 's/.function..Factlink...{//' | \
		sed 's/}...window\.Factlink..;//' | \
		sed 's/@DATE/'"${DATE}"'/' | \
		${VER} > ${FACTLINK_TMP};

	node Makefile.js

	@@rm ${FACTLINK_TMP}

min: factlink ${FACTLINK_MIN}
	@@echo "Minifying core"

clean:
	@@echo "Removing Distribution directory:" ${DIST_DIR}
	@@rm -rf ${DIST_DIR}

test:
	@@echo "Running tests using smoosh:"
	node make/test.js

.PHONY: all factlink min clean test