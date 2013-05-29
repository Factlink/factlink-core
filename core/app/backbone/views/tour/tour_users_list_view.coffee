class TourUserView extends ActionButtonView
  template: 'tour/interesting_user'
  className: 'tour-interesting-user'

  enableHoverState: ->
    return if @justClicked
    super
    @$el.addClass 'hover'

  disableHoverState: ->
    super
    @$el.removeClass 'hover'

  updateButton: ->
    super
    @$el.toggleClass 'secondary', @buttonEnabled()

  buttonEnabled: ->
    @somestate # TODO

  primaryAction: ->
    #TODO follow + favourite topics
    @somestate = true
    @updateButton()

  secondaryAction: ->
    #TODO unfollow
    @somestate = false
    @updateButton()

class window.TourUsersListView extends Backbone.Marionette.CollectionView
  itemView: TourUserView
