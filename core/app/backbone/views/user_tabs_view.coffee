class window.UserTabsView extends Backbone.Marionette.ItemView
  template: 'users/tabs'
  tagName: 'ul'

  triggers:
    'click .js-tab-show': 'showProfile'
    'click .js-tab-notification-settings': 'showNotifications'

  onRender: -> @showActiveTab()

  activate: (tab) ->
    @options.active_tab = tab
    @showActiveTab()

  showActiveTab: ->
    @$('a').removeClass('active')
    @$('a.js-tab-' + @options.active_tab).addClass('active') if @options.active_tab
