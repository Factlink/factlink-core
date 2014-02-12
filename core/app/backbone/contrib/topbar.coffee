# class BookmarkletTooltipView extends Backbone.Marionette.ItemView
#   template:
#     text: """
#       You can drag this Bookmarklet to your bookmarks bar.<br>
#       Suitable for browsers other than Chrome and Firefox.
#     """

# class TopbarDropdownMenuView extends Backbone.View
#   render: ->
#     Backbone.Factlink.makeTooltipForView @,
#       positioning:
#         side: 'left'
#         popover_className: 'translucent-popover'
#       selector: '.js-topbar-dropdown-menu-bookmarklet'
#       tooltipViewFactory: => new BookmarkletTooltipView

ReactBookmarklet = React.createBackboneClass
  displayName: 'ReactBookmarklet'

  getInitialState: ->
    hovered: false

  render: ->
    _a ['topbar-menu-bookmarklet'
      href: Factlink.Global.bookmarklet_link
      onMouseEnter: => @setState(hovered: true)
      onMouseLeave: => @setState(hovered: false)
    ],
      _i ['icon-bookmark']
      _span [style: {display: 'none'}],
        'Factlink'
      if @state.hovered
        ReactPopover {},
          _div [],
            "You can drag this Bookmarklet to your bookmarks bar."

$ ->
  menuItemElement = $('.js-topbar-dropdown-menu-bookmarklet')[0]
  React.renderComponent ReactBookmarklet(), menuItemElement if menuItemElement?

$('#factlink_search').on 'focus', ->
  mp_track "Search: Top bar search focussed"
