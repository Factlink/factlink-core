dirname $0§
cd `dirname $0`
cd impl_prune_dead_feature_builds

bundle && bundle exec ruby prune_dead_feature_builds.rb
