cd `dirname $0`
pushd impl_prune_dead_feature_builds

bundle && bundle exec ruby prune_dead_feature_builds.rb
popd

. ./lib.sh

curl --user $CREDENTIALS -s --data-urlencode "script@impl_prune_dead_feature_builds/delete_dead_workspaces.groovy" "$JENKINS_URL/scriptText"
