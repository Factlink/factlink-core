class window.TourInterestingUsersView extends Backbone.Marionette.Layout

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
    scrollingInner: '.js-scrolling-inner'

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

    @bindTo currentUser, 'follow_action', @updateFinishButton
    @updateFinishButton()

  updateShuffledCollection: ->
    @shuffledCollection.reset @collection.shuffle()
    @resizeScrollingInner()
    @updateButtonStates()
    @listView().children.first()?.showAuthorityPopover()

  listView: ->
    @_listView ?= new TourUsersListView
      collection: @shuffledCollection

  updateFinishButton: ->
    @showFinishButton() if currentUser.is_following_users()

  showFinishButton: ->
    @ui.skip.fadeOut =>
      @ui.finish.fadeIn()

  resizeScrollingInner: ->
    width = @userListItemWidth() * @totalNumberOfItemsInX()
    @ui.scrollingInner.width width

  showPage: (page) ->
    @page = page
    xOffset = @userListItemWidth() * @numberOfUsersInX * @page
    @ui.scrollingInner.css 'left', -xOffset
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
    Math.ceil(@shuffledCollection.size() / @numberOfUsersInY)

  userListItemWidth: ->
    # Return some random number so on subsequent renders the
    # TourUserViews are not clipped
    return 500 if @shuffledCollection.isEmpty()

    # width of TourUserView including margin
    @listView().children.first().$el.outerWidth(true)

  updateButtonStates: ->
    @ui.left.toggleClass  'enabled', @hasPreviousPage()
    @ui.right.toggleClass 'enabled', @hasNextPage()
