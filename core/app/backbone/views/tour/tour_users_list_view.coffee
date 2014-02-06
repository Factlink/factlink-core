class TourUserView extends Backbone.Marionette.Layout

  template: 'tour/interesting_user'
  className: 'tour-interesting-user'

  regions:
    buttonRegion: '.js-region-button'

  onRender: ->
    @buttonRegion.show @followUserButton()

  followUserButton: ->
    unless @_followUserButton?
      @_followUserButton = new FollowUserButtonView
        user: @cloned_user()
        $listenToEl: @$el

      @listenTo @_followUserButton, 'render_state', (loaded, hovering, checked) ->
        @$el.toggleClass 'hover', hovering and loaded
        @$el.toggleClass 'secondary', checked and loaded
        @$el.toggleClass 'loaded', loaded

    @_followUserButton


  cloned_user: -> @_cloned_user ?= @model.clone()

class window.TourUsersListView extends Backbone.Marionette.CollectionView
  itemView: TourUserView
  className: 'tour-interesting-users-list'
  emptyView: Backbone.Factlink.LoadingView

  onRender: ->
    @$el.toggleClass 'tour-interesting-users-list-empty', @collection.isEmpty()
