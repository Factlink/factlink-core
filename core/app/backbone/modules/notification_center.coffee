FactlinkApp.module "NotificationCenter", (NotificationCenter, MyApp, Backbone, Marionette, $, _) ->

  class NotificationCenter.AlertView extends Marionette.ItemView

    initialize: ->
      @$el.addClass "alert alert-#{@model.get('type')}"

    template:
      text: "{{{message}}} <a class='close'>&times;</a>"

    events:
      "click .close": -> @model.destroy()

  class NotificationCenter.AlertsView extends Marionette.CollectionView
    itemView: NotificationCenter.AlertView

  class NotificationCenter.Alert extends Backbone.Model
  class NotificationCenter.Alerts extends Backbone.Collection
  window.alerts = new NotificationCenter.Alerts []

  FactlinkApp.addRegions
    alertsRegion: "#alerts"
  FactlinkApp.alertsRegion.show new NotificationCenter.AlertsView collection: alerts

  NotificationCenter.info    = (message) -> alerts.add new NotificationCenter.Alert message: message, type: 'info'
  NotificationCenter.success = (message) -> alerts.add new NotificationCenter.Alert message: message, type: 'success'
  NotificationCenter.error   = (message) -> alerts.add new NotificationCenter.Alert message: message, type: 'error'
