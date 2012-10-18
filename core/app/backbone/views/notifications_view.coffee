class NotificationsEmptyView extends Backbone.Marionette.ItemView
   template: "notifications/_notifications"


class window.NotificationsView extends Backbone.Factlink.CompositeView
  tagName: "li"
  id: "notifications"
  itemViewContainer: "ul.dropdown-menu"
  emptyView: NotificationsEmptyView
  events:
    click: "clickHandler"

  template: "notifications/_notifications"
  initialize: ->
    @itemView = NotificationView
    @setupNotificationsFetch()
    @_unreadCount = 0
    @views = {}
    @on "itemview:activityActivated", ->
      @hideDropdown()

  onRender: ->
    @$el.css visibility: "visible"
    @setUnreadCount @collection.unreadCount()
    @$el.find("ul").preventScrollPropagation()

  setUnreadCount: (count) ->
    $unread = @$("span.unread")
    @_unreadCount = count
    @_unreadTitleCount = count
    if count > 0
      $unread.addClass "active"
    else
      $unread.removeClass "active"
    if count > 9
      @_unreadCount = "9<sup>+</sup>"
      @_unreadTitleCount = 9
    $unread.html @_unreadCount
    TitleManager.set "notificationsCount", @_unreadTitleCount

  markAsRead: ->
    self = this
    @collection.markAsRead success: ->
      self.markViewsForUnreadification()
      self.setUnreadCount 0

  markViewsForUnreadification: ->
    @_shouldMarkUnread = true

  setupNotificationsFetch: ->
    doReloading = ->
      not (typeof localStorage is "object" and localStorage isnt null and localStorage["reload"] is "false")
    refreshAgain = (always) ->
      if always or doReloading()
        setTimeout (->
          args.callee.apply self, args
        ), 7000
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
    @$el.addClass("open").find("ul").show()
    @markAsRead()
    @_bindWindowClick()

  hideDropdown: ->
    @_visible = false
    @$el.removeClass("open").find("ul").hide()
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

_.extend NotificationsView::, TemplateMixin
