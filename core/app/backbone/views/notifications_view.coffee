class window.NotificationsView extends Backbone.Factlink.CollectionView
  tagName: "li"
  id: "notifications"
  itemViewContainer: "ul"
  events:
    click: "clickHandler"

  template: "notifications/_notifications"
  initialize: ->
    @collection.on "add", @add, this
    @collection.on "reset", @reset, this
    @modelView = NotificationView
    @setupNotificationsFetch()
    @_unreadCount = 0
    @views = {}

  render: ->
    @$el.find("ul.dropdown-menu").html @templateRender()
    if @collection.length is 0
      @$el.find("li.no-notifications").removeClass "hidden"
    else
      @$el.find("li.no-notifications").addClass "hidden"
      super(arguments)
    @$el.find("ul").preventScrollPropagation()
    this

  beforeReset: ->
    @setUnreadCount 0

  afterAdd: (notification) ->
    @setUnreadCount @_unreadCount + 1  if notification.get("unread") is true

  setUnreadCount: (count) ->
    $unread = @$el.find("span.unread")
    @$el.css visibility: "visible"
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
        error: refreshAgain
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
