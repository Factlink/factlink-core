class window.UserTabsView extends Backbone.Marionette.ItemView
  template: 'users/tabs'
  tagName: 'ul'

  triggers:
    'click .tab-show a': 'showProfile'
    'click .tab-notification-settings': 'showNotifications'

  onRender: -> @showActiveTab()

  activate: (tab)->
    @options.active_tab = tab
    @showActiveTab()

  showActiveTab: ->
    @$('li').removeClass('active')
    @$('.tab-' + @options.active_tab).addClass('active') if @options.active_tab

