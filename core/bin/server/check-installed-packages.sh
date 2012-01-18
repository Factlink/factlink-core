#!/bin/bash

# Check if there is 1 occurence of the package defined in apt-requirements in
# the dpkg -l, listing of installed packages on this system.

for line in $(cat apt-requirements.txt); do

  count=`dpkg --get-selections | cut -f1 | grep -e ^$line$ -c`

  if [ "$count" -eq "1" ]; then
    # Installed
    echo "$line is installed"
  else
    echo "Package '$line' is not installed. Please install."
    exit 1
  fi
done

exit 0