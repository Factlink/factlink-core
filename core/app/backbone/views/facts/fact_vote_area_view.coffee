class OpinionatorsAvatarView extends Backbone.Marionette.Layout
  tagName: 'span'
  className: 'opinionators-avatar'
  template: 'opinionators/avatar'

  templateHelpers: =>
    user: @model.user().toJSON()

  onRender: ->
    UserPopoverContentView.makeTooltip @, @model.user()


class window.FactVoteTableView extends Backbone.Marionette.CompositeView
  tagName: 'div'
  className: 'fact-vote-area'
  template: 'facts/fact_vote_area'
  itemView: OpinionatorsAvatarView

  ui:
    avatarsBelievesRegion: '.js-avatars-believes-region'
    avatarsDisbelievesRegion: '.js-avatars-disbelieves-region'

  events:
    'click .js-button-believes': ->
      @collection.clickCurrentUserOpinion 'believes'
    'click .js-button-disbelieves': ->
      @collection.clickCurrentUserOpinion 'disbelieves'

  initialize: ->
    @collection = @model.getVotes()
    @collection.fetch reset: true

  _initialEvents: ->
    @listenTo @collection, 'reset add remove change', @render, @

  appendHtml: (collectionView, itemView, index) ->
    return unless itemView.model.get('type') in ['believes', 'disbelieves']

    @typeRegionForVote(itemView.model).append itemView.el

  typeRegionForVote:(model) ->
    switch model.get('type')
      when 'believes'    then @ui.avatarsBelievesRegion
      when 'disbelieves' then @ui.avatarsDisbelievesRegion

  onRender: ->
    @_updateActiveCell()
    @$('.fact-vote-stats table').hide() # functionality will be implemented with conversion to react

  _updateActiveCell: ->
    opinion = @collection.opinion_for_current_user()
    @$('.fact-vote-button-active').removeClass 'fact-vote-button-active'
    @$(".vote-column-#{opinion}-button").addClass 'fact-vote-button-active'
