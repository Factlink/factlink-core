#!/bin/bash

# sort -d is to make sure the file order is always the same
CURRENT_SHASUM=`shasum -b $(ls config/locales/* | sort -d) | shasum -b | perl -pe 's/\s*\*-\s*//'`
RECORDED_SHASUM=`cat app/assets/javascripts/globals/globals.coffee.erb  | grep '# SHASUM' | perl -pe 's/.*:\s*//'`

echo "This script checks if locales have been updated, as Rails doesn't check these files"
echo "You can also run this script locally using 'bin/ci/105_check_assets_updated.sh'"
echo ""

echo "Using the following files for SHASUM (note the order, especially files with underscores..):"
ls -la config/locales/* | sort -d

echo ""
echo "SHASUM of these files: $CURRENT_SHASUM"
echo "SHASUM in globals.coffee.erb: $RECORDED_SHASUM"


if [ "$CURRENT_SHASUM" != "$RECORDED_SHASUM" ]; then
  echo "Please update the SHASUM in globals.coffee.erb to '$CURRENT_SHASUM'"

  echo "For debugging purposes:"
  LC_ALL=C shasum -b $(ls config/locales/* | sort -d)

  exit 1
else
  echo "SHASUM matches!"
  exit 0
fi
