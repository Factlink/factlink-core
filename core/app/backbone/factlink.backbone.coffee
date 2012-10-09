#= require jquery
#= require underscore
#= require trunk8

#= require backbone
#= require backbone.marionette

#= require twipsy

#= require hogan
#= require_tree ../templates

this.HoganTemplates || (this.HoganTemplates = {});

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
#= require_tree ./controllers/
#= require_tree ./routers/
#= require ./initializers.js
