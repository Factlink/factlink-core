#!/bin/bash
echo "Running security check"

bundle exec brakeman --except SessionSettings -q -o /tmp/brakeman.tabs || exit 1

cat /tmp/brakeman.tabs

exit `cat bin/ci/103_security_ignore.txt | perl -pe 's/#.*$//'|grep -E '.' | perl -e '$_=join"|",<>;s/\n//g;chomp;print"grep -vE \"".$_."\"  /tmp/brakeman.tabs\n"' | sh | grep -E . | wc -l`
