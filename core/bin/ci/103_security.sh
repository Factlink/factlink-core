#!/bin/bash
echo "Running security check"
source "$HOME/.rvm/scripts/rvm"
rvm use --default 1.9.2-p290 || exit 1
bundle exec brakeman -o /tmp/brakeman_tabs || exit 1
cat bin/ci/103_security_ignore.txt | grep -E '.' | perl -e '$_=join"|",<>;s/\n//;chomp;print"grep -vE \"".$_."\"  /tmp/brakeman_tabs\n"' | sh
exit