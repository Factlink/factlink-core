#!/bin/bash

cd `dirname $0`/..

export DEST="$CIRCLE_ARTIFACTS/";

find . | \
  grep spec/fixtures/approvals | \
  grep received | \
  perl -pe 's#./spec/fixtures/approvals/(.*)/(.*)#mkdir -p '"$DEST"'$1\n cp $& '"$DEST"'$1/$2#' \
  > tmp/copy_fixtures.sh

chmod +x tmp/copy_fixtures.sh
tmp/copy_fixtures.sh
