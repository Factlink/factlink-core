class NotificationsEmptyView extends Backbone.Marionette.ItemView
   template: "notifications/notifications_empty"


class window.NotificationsView extends Backbone.Factlink.CompositeView
  itemViewContainer: "ul.dropdown-menu"
  emptyView: NotificationsEmptyView
  template: "notifications/notifications"

  events:
    "click .unread": "clickHandler"

  ui:
    unread: '.unread'

  initialize: ->
    @itemView = NotificationView
    @setupNotificationsFetch()
    @_unreadCount = 0
    @views = {}
    @on "itemview:activityActivated", ->
      @hideDropdown()

  onRender: ->
    @$("ul").preventScrollPropagation()
    @listenTo @collection, 'sync', @updateUnreadCount

  updateUnreadCount: ->
    @setUnreadCount @collection.unreadCount()

  setUnreadCount: (count) ->
    @_unreadCount = count
    @_unreadTitleCount = count
    if count > 0
      @ui.unread.addClass "active"
    else
      @ui.unread.removeClass "active"
    if count > 9
      @_unreadCount = "9<sup>+</sup>"
      @_unreadTitleCount = 9
    @ui.unread.html @_unreadCount
    TitleManager.set "notificationsCount", @_unreadTitleCount

  markAsRead: ->
    @collection.markAsRead
      success: =>
        @markViewsForUnreadification()
        @setUnreadCount 0

  markViewsForUnreadification: ->
    @_shouldMarkUnread = true

  setupNotificationsFetch: ->
    doReloading = ->
      getSetting("reload") isnt "false"
    refreshAgain = (always) ->
      if always or doReloading()
        setTimeout (->
          args.callee.apply self, args
        ), 59*1000
    args = arguments
    self = this
    unless @_visible
      @collection.fetch
        success: refreshAgain
        error: (collection, response)->
          if response.status is 403
            responsecode = JSON.parse(response.responseText).code
            # should be: responsecode is 'login'
            # but devise doesn't add a code
            console.info responsecode
            if responsecode isnt 'tos'
              FactlinkApp.vent.trigger('require_login')
          refreshAgain()
    else
      refreshAgain true

  clickHandler: (e) ->
    if @_visible
      @hideDropdown()
    else
      @showDropdown()
    e.stopPropagation()

  showDropdown: ->
    @_visible = true
    $('#notifications').addClass "open"
    @$("ul").show()
    @markAsRead()
    @_bindWindowClick()

  hideDropdown: ->
    @_visible = false
    $('#notifications').removeClass "open"
    @$("ul").hide()
    if @_shouldMarkUnread is true
      @_shouldMarkUnread = false
      _.forEach @views, (view) ->
        view.markAsRead()
    @_unbindWindowClick()

  _bindWindowClick: ->
    $(window).on "click.notifications", (e) =>
      this.hideDropdown()  unless $(e.target).closest("ul").is("#notifications-dropdown")

  _unbindWindowClick: ->
    $(window).off "click.notifications"
