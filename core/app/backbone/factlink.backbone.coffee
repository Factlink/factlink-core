#= require backbone
#= require backbone.marionette
#= require backbone.paginator
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
#= require_tree ./controllers/
#= require_tree ./routers/
#= require_tree ./initializers

this.HoganTemplates || (this.HoganTemplates = {});
