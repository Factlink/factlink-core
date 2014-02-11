#= require backbone
#  queryparams patches router, so should be loaded before marionette,
#     which subclasses the router
#= require backbone.queryparams
#= require backbone.marionette
#= require react
#= require react.backbone

# Replace by just 'require tether' when
# this has been merged: https://github.com/HubSpot/tether/pull/25
#= require tether/utils
#= require tether/tether
#= require tether/constraint
#= require tether/abutment
#= require tether/shift

#= require_tree ../templates
#= require_self

#= require_tree ./contrib
#= require_tree ./factlink
#= require_tree ./mixins
#= require_tree ./components

#= require app.js
#= require_tree ./modules
#= require_tree ./models/
#= require_tree ./collections/
#= require_tree ./layouts/
#= require_tree ./views/
#= require_tree ./controllers/
#= require_tree ./routers/
#= require_tree ./initializers

#= require_tree ./client

# ensure that HoganTemplate exists, also when no templates are loaded
# (for instance in tests)
this.HoganTemplates || (this.HoganTemplates = {});
