SRC_DIR = src
TEST_DIR = test
BUILD_DIR = build

PREFIX = .
DIST_DIR = ${PREFIX}/dist

BASE_FILES = ${SRC_DIR}/core.js\
	${SRC_DIR}/create.js\
	${SRC_DIR}/loader.js\
	${SRC_DIR}/proxy.js\
	${SRC_DIR}/replace.js\
	${SRC_DIR}/search.js\

MODULES = ${SRC_DIR}/intro.js\
	${BASE_FILES}\
	${SRC_DIR}/outro.js

FL_VER = $(shell cat version.txt)
VER = sed "s/@VERSION/${FL_VER}/"

FACTLINK = ${DIST_DIR}/factlink.js
FACTLINK_MIN = ${DIST_DIR}/factlink.min.js

DATE=$(shell git log -1 --pretty=format:%ad)

all: factlink min
	@@echo "Factlink client library build complete"

${DIST_DIR}:
	@@mkdir -p ${DIST_DIR}

factlink: ${FACTLINK}

${FACTLINK}: ${MODULES} | ${DIST_DIR}
	@@echo "Building" ${Factlink}

	@@cat ${MODULES} | \
		sed 's/.function..Factlink...{//' | \
		sed 's/}...Factlink..;//' | \
		${VER} > ${FACTLINK};

min: factlink ${FACTLINK_MIN}
	@@echo "Minifying core"

clean:
	@@echo "Removing Distribution directory:" ${DIST_DIR}
	@@rm -rf ${DIST_DIR}

.PHONY: all factlink min clean