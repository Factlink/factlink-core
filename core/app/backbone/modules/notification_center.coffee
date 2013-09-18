FactlinkApp.module "NotificationCenter", (NotificationCenter, MyApp, Backbone, Marionette, $, _) ->

  class NotificationCenter.AlertView extends Marionette.ItemView

    className: 'notification-center-alert-container'

    template: 'widgets/notification_center_alert'

    events:
      "click .js-close": '_destroy'

    onRender: ->
      @_autoHide()

    _autoHide: ->
      return unless @model.get('type') == 'success'

      setTimeout (=> @_destroy()), @_autoHideTime()

    _autoHideTime: -> 1000 + 50*@model.get('message').length

    _destroy: ->
      @$el.addClass 'notification-center-alert-container-hidden'

      transitionTime = 500 # Keep in sync with transition in notification_center.css.less
      setTimeout (=> @model.destroy()), transitionTime+100 # Destroy strictly after animation

  class NotificationCenter.AlertsView extends Marionette.CollectionView
    itemView: NotificationCenter.AlertView

  class NotificationCenter.Alert extends Backbone.Model
  class NotificationCenter.Alerts extends Backbone.Collection
  window.alerts = new NotificationCenter.Alerts []

  FactlinkApp.addRegions
    alertsRegion: ".js-notification-center-alerts"
  FactlinkApp.alertsRegion.show new NotificationCenter.AlertsView collection: alerts

  NotificationCenter.success = (message) -> alerts.add new NotificationCenter.Alert message: message, type: 'success'
  NotificationCenter.error   = (message) -> alerts.add new NotificationCenter.Alert message: message, type: 'error'
