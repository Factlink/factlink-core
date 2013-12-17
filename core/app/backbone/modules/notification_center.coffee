FactlinkApp.module "NotificationCenter", (NotificationCenter, FactlinkApp, Backbone, Marionette, $, _) ->

  class NotificationCenter.AlertView extends Marionette.ItemView

    className: 'notification-center-alert-container'

    template: 'widgets/notification_center_alert'

    events:
      "click .js-close": '_destroy'
      "click .js-action": '_actionCallback'

    onRender: ->
      @_autoHide()

    _autoHide: ->
      return unless @model.get('type') == 'success'

      setTimeout (=> @_destroy()), @_autoHideTime()

    _autoHideTime: ->
      extraTimeForAction = if @model.has('action') then 10000 else 0

      1000 + 50*@model.get('message').length + extraTimeForAction

    _destroy: ->
      @$el.addClass 'notification-center-alert-container-hidden'

      transitionTime = 500 # Keep in sync with transition in notification_center.css.less
      setTimeout (=> @model.destroy()), transitionTime+100 # Destroy strictly after animation

    _actionCallback: ->
      @_destroy()
      @model.get('callback')()

  class NotificationCenter.AlertsView extends Marionette.CollectionView
    itemView: NotificationCenter.AlertView

  class NotificationCenter.Alert extends Backbone.Model
  class NotificationCenter.Alerts extends Backbone.Collection
  window.alerts = new NotificationCenter.Alerts []

  FactlinkApp.addRegions
    alertsRegion: ".js-notification-center-alerts"
  FactlinkApp.alertsRegion.show new NotificationCenter.AlertsView collection: alerts

  NotificationCenter.success = (message, action=null, callback=->) ->
    alerts.add new NotificationCenter.Alert {message, action, callback, type: 'success'}

  NotificationCenter.error   = (message, action=null, callback=->) ->
    alerts.add new NotificationCenter.Alert {message, action, callback, type: 'error'}
