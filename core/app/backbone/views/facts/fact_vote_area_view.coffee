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
    avatarsDoubtsRegion: '.js-avatars-doubts-region'
    avatarsDisbelievesRegion: '.js-avatars-disbelieves-region'

  events:
    'click .js-button-believes': ->
      @collection.clickCurrentUserOpinion 'believes'
    'click .js-button-doubts': ->
      @collection.clickCurrentUserOpinion 'doubts'
    'click .js-button-disbelieves': ->
      @collection.clickCurrentUserOpinion 'disbelieves'

  initialize: ->
    @collection = @model.getVotes()
    @collection.fetch reset: true

  _initialEvents: ->
    @listenTo @collection, 'reset add remove change', @render, @

  appendHtml: (collectionView, itemView, index) ->
    @typeRegionForVote(itemView.model).append itemView.el

  typeRegionForVote:(model) ->
    switch model.get('type')
      when 'believes'    then @ui.avatarsBelievesRegion
      when 'disbelieves' then @ui.avatarsDisbelievesRegion
      when 'doubts'      then @ui.avatarsDoubtsRegion

  onRender: ->
    @_updateActiveCell()

  _updateActiveCell: ->
    opinion = @collection.opinion_for_current_user()
    @$('.fact-vote-table-cell-active').removeClass 'fact-vote-table-cell-active'
    @$(".js-cell-#{opinion}").addClass 'fact-vote-table-cell-active'
