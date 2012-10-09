#= require backbone
#= require backbone.marionette

#= require_tree ../templates
#= require_self

#= require_tree ./contrib
#= require_tree ./factlink

#= require app.js
#= require ./notification_center/app
#= require_tree ./models/
#= require_tree ./collections/
#= require_tree ./layouts/
#= require_tree ./views/
#= require_tree ./views/channels/
#= require_tree ./views/users/
#= require_tree ./views/facts/
#= require_tree ./controllers/
#= require_tree ./routers/
#= require_tree ./initializers

this.HoganTemplates || (this.HoganTemplates = {});
