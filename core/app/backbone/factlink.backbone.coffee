#= require backbone
#  queryparams patches router, so should be loaded before marionette,
#     which subclasses the router
#= require backbone.queryparams
#= require backbone.marionette
#= require react/react-with-addons
#= require react.backbone

#= require tether

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
#= require_tree ./initializers
