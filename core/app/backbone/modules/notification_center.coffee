class Alert extends Backbone.Model
class Alerts extends Backbone.Collection

ReactAlerts = React.createBackboneClass
  render: ->
    React.addons.CSSTransitionGroup {
        transitionName: "notification-center-alert-container"
        transitionEnter: false
      },
      @props.model.map (model) ->
        _div [
            'notification-center-alert-container'
            key: model.cid
          ],
          _div [
              "notification-center-alert"
              "notification-center-alert-#{model.get('type')}"
            ],
            _span [dangerouslySetInnerHTML: {__html: model.get('message')}]
            if model.get('show_close')
              [
                _span [style: {width: '10px', display: 'inline-block'}] # spacer span
                _span ["notification-center-alert-close", onClick: -> model.destroy()],
                  '×'
              ]

autoHideTime = (alert)-> 1000 + 50*alert.get('message').length

autoRemove = (alert) ->
  return if Factlink.Global.enviroment == 'test'

  setTimeout (-> alert.destroy()), autoHideTime(alert)


class window.NotificationCenter
  constructor: (selector)->
    @alerts = new Alerts []
    alertComponent = ReactAlerts(model: @alerts)
    React.renderComponent(alertComponent, document.querySelector(selector))

  success: (message) ->
    success_alert = new Alert {message, type: 'success', show_close: false}
    @alerts.add success_alert

    autoRemove(success_alert)

  error: (message) ->
    @alerts.add new Alert {message, type: 'error', show_close: true}
