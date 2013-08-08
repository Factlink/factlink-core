class window.TourInterestingUsersView extends Backbone.Marionette.Layout

  template: 'tour/interesting_users_layout'
  className: 'tour-interesting-users'

  events:
    'click .js-left':   'showPreviousPage'
    'click .js-right':  'showNextPage'
    'click .js-finish': 'onClickFinish'

  regions:
    tourUsersRegion: '.js-region-tour-users'

  ui:
    left:   '.js-left'
    right:  '.js-right'
    skip:   '.js-skip'
    finish: '.js-finish'
    scrollingInner: '.js-scrolling-inner'

  templateHelpers: ->
    next_tourstep_path: window.next_tourstep_path

  initialize: ->
    @page = 0
    @shuffledCollection = new TourUsers

    @options.numberOfUsersInX ?= 4
    @options.numberOfUsersInY ?= 2

  onRender: ->
    @ui.finish.hide()
    @tourUsersRegion.show @listView()

    @listenTo @collection, 'add remove reset', @updateShuffledCollection
    @updateShuffledCollection()

    @listenTo currentUser.following, 'sync', @updateFinishButton
    @updateFinishButton()

  updateShuffledCollection: ->
    @shuffledCollection.reset @collection.shuffle()
    @resizeScrollingInner()
    @updateButtonStates()
    @listView().children.first()?.showAuthorityPopover?()

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
    xOffset = @userListItemWidth() * @options.numberOfUsersInX * @page
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
    (@page+1) * @options.numberOfUsersInX < @totalNumberOfItemsInX()

  totalNumberOfItemsInX: ->
    Math.ceil(@shuffledCollection.size() / @options.numberOfUsersInY)

  userListItemWidth: ->
    # Fixed width from options overrides calculation
    if @options.userListItemWidth?
      return @options.userListItemWidth

    # Return some random number so on subsequent renders the
    # TourUserViews are not clipped
    if @shuffledCollection.isEmpty()
      return 500

    # width of TourUserView including margin
    @listView().children.first().$el.outerWidth(true)

  updateButtonStates: ->
    @ui.left.toggleClass  'enabled', @hasPreviousPage()
    @ui.right.toggleClass 'enabled', @hasNextPage()

  onClickFinish: ->
    window.disableInputWithDisableWith @ui.finish
