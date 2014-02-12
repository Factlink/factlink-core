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
        'Factlink' # Caption of the link in the bookmarks bar
      if @state.hovered
        ReactPopover {},
          _div [],
            "You can drag this Bookmarklet to your bookmarks bar."

$ ->
  menuItemElement = $('.js-topbar-dropdown-menu-bookmarklet')[0]
  React.renderComponent ReactBookmarklet(), menuItemElement if menuItemElement?

$('#factlink_search').on 'focus', ->
  mp_track "Search: Top bar search focussed"
