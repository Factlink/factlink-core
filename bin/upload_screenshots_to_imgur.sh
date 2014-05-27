#!/bin/bash

# Adapted from http://twolfson.com/2014-02-25-visual-regression-testing-in-travis-ci

# Install underscore-cli for hacking
if ! which underscore &> /dev/null; then
  npm install -g underscore-cli
fi

cd tmp/capybara

output_dir="spec/screenshots/screenshots"
download_cmds=""

# curl from http://imgur.com/tools/imgurbash.sh via http://imgur.com/tools
# Documentation: http://code.google.com/p/imgur-api/source/browse/wiki/ImageUploading.wiki?r=82
# Also: http://planspace.blogspot.nl/2013/01/upload-images-to-your-imgur-account.html

IMGUR_CLIENT_ID="38138fab8a0b549"
for filepath in *.png; do
  result="$(curl -X POST -H "Authorization: Client-ID $IMGUR_CLIENT_ID" -F "image=@$filepath" https://api.imgur.com/3/upload )"
  if test "$(echo "$result" | underscore extract 'success')" != 'true'; then
    echo "There was a problem uploading \"$filepath\"" 1>&2
    echo "$result" 1>&2
  else
    download_cmds="${download_cmds}wget -O \"$output_dir/$filepath\" $(echo "$result" | underscore extract 'data.link')\n"
  fi
done

echo "All uploads complete!"
echo ""
echo "Download via:"
echo -e "$download_cmds"
