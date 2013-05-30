class TourAuthorityPopover extends Backbone.Marionette.ItemView
  template: 'tour/authority_popover'

  triggers:
    'click .js-next': 'next'

class window.TourInterestingUsersView extends Backbone.Marionette.Layout

  _.extend @prototype, Backbone.Factlink.TooltipMixin

  template: 'tour/interesting_users_layout'
  className: 'tour-interesting-users'

  events:
    'click .js-left':  'showPreviousPage'
    'click .js-right': 'showNextPage'

  regions:
    tourUsersRegion: '.js-region-tour-users'

  ui:
    left:   '.js-left'
    right:  '.js-right'
    skip:   '.js-skip'
    finish: '.js-finish'

  userListItemWidth: 200 + 2*20 # width of .tour-interesting-user including margin
  numberOfUsersInX: 4
  numberOfUsersInY: 2

  templateHelpers: ->
    next_tourstep_path: window.next_tourstep_path

  initialize: ->
    @page = 0
    @shuffledCollection = new TourUsers

  onRender: ->
    @ui.finish.hide()
    @tourUsersRegion.show @listView()

    @bindTo @collection, 'add remove reset', @updateShuffledCollection
    @updateShuffledCollection()

  updateShuffledCollection: ->
    @shuffledCollection.reset @collection.shuffle()
    @resizeListView()
    @updateButtonStates()
    @showAuthorityPopover()

  authorityPopover: ->
    unless @_authorityPopover?
      @_authorityPopover = new TourAuthorityPopover
      @bindTo @_authorityPopover, 'next', @tooltipResetAll
    @_authorityPopover

  showAuthorityPopover: ->
    return if @shuffledCollection.isEmpty()

    @tooltipAdd '.js-topic', "What is this?", "",
      side: 'right'
      align: 'top'
      orthogonalOffset: -2
      contentView: @authorityPopover()
      show_overlay: true
      focus_on: @$('.js-topic')[0]

  listView: ->
    @_listView ?= new TourUsersListView
      collection: @shuffledCollection

  showFinishButton: ->
    @ui.skip.fadeOut =>
      @ui.finish.fadeIn()

  resizeListView: ->
    width = @userListItemWidth * @totalNumberOfItemsInX()
    @listView().$el.width width

  showPage: (page) ->
    @page = page
    xOffset = @userListItemWidth * @numberOfUsersInX * @page
    @listView().$el.css 'left', -xOffset
    @updateButtonStates()

  showPreviousPage: ->
    return unless @hasPreviousPage()
    @showPage @page-1

  showNextPage: ->
    return unless @hasNextPage()
    @showPage @page+1

  hasPreviousPage: ->
    @page > 0

  hasNextPage: ->
    (@page+1) * @numberOfUsersInX < @totalNumberOfItemsInX()

  totalNumberOfItemsInX: ->
    Math.ceil(@collection.size() / @numberOfUsersInY)

  updateButtonStates: ->
    @ui.left.toggleClass  'enabled', @hasPreviousPage()
    @ui.right.toggleClass 'enabled', @hasNextPage()
