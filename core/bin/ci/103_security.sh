#!/bin/bash
echo "Running security check"
source "$HOME/.rvm/scripts/rvm"
rvm use 1.9.2-p290 || exit 1
bundle || exit 1
bundle exec brakeman -o /tmp/brakeman.tabs || exit 1
cat /tmp/brakeman.tabs
exit `cat bin/ci/103_security_ignore.txt | perl -pe 's/#.*$//'|grep -E '.' | perl -e '$_=join"|",<>;s/\n//;chomp;print"grep -vE \"".$_."\"  /tmp/brakeman.tabs\n"' | sh | grep -E . | wc -l`