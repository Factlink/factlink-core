#!/bin/bash

# Check if there is 1 occurence of the package defined in apt-requirements in
# the dpkg -l, listing of installed packages on this system.

is_missing_packages=false
the_missing_packages=""

for line in $(cat /applications/factlink-core/current/config/apt-requirements.txt); do
  count=`dpkg --get-selections | cut -f1 | grep -e ^$line$ -c`

  if [ "$count" -eq "1" ]; then
    # Installed
    echo "$line is installed"
  else
    the_missing_packages="$the_missing_package $line"
    is_missing_packages=true
  fi

done

if $is_missing_packages ; then
  echo "Not all required packages are installed. The following packages are missing: $the_missing_packages"
  exit 1
else
  echo "Success: All required packages from apt-packages.txt are installed."
  exit 0
fi