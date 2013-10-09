class BookmarkletTooltipView extends Backbone.Marionette.ItemView
  template:
    text: """
      You can drag this Bookmarklet to your bookmarks bar.<br>
      Suitable for browsers other than Chrome and Firefox.
    """

class TopbarDropdownMenuView extends Backbone.View
  render: ->
    Backbone.Factlink.makeTooltipForView @,
      positioning:
        side: 'left'
        popover_className: 'translucent-dark-popover'
      selector: '.js-topbar-dropdown-menu-bookmarklet'
      tooltipViewFactory: => new BookmarkletTooltipView

$ ->
  (new TopbarDropdownMenuView(el: $('.js-topbar-dropdown-menu'))).render()

$('#factlink_search').on 'focus', ->
  mp_track "Search: Top bar search focussed"
