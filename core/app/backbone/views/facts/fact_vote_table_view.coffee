class OpinionatorsAvatarView extends Backbone.Marionette.Layout
  tagName: 'span'
  className: 'opinionators-avatar'
  template: 'opinionators/avatar'

  templateHelpers: =>
    user: @model.user().toJSON()

  onRender: ->
    UserPopoverContentView.makeTooltip @, @model


class window.FactVoteTableView extends Backbone.Marionette.CompositeView
  tagName: 'table'
  className: 'fact-vote-table'
  template: 'facts/fact_vote_table'
  itemView: OpinionatorsAvatarView

  ui:
    avatarsBelievesRegion: '.js-avatars-believes-region'
    avatarsDoubtsRegion: '.js-avatars-doubts-region'
    avatarsDisbelievesRegion: '.js-avatars-disbelieves-region'

  events:
    'click .js-button-believes': -> @_tally.clickCurrentUserOpinion 'believes'
    'click .js-button-doubts': -> @_tally.clickCurrentUserOpinion 'doubts'
    'click .js-button-disbelieves': -> @_tally.clickCurrentUserOpinion 'disbelieves'

  initialize: ->
    @_tally = @model.getFactTally()
    @listenTo @_tally, 'change:current_user_opinion', @_updateActiveCell
    @listenTo @_tally, 'sync', -> @collection.fetch()

    @collection = @model.getVotes()
    @collection.fetch()

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
    opinion = @_tally.get('current_user_opinion')
    @$('.fact-vote-table-cell-active').removeClass 'fact-vote-table-cell-active'
    @$(".js-cell-#{opinion}").addClass 'fact-vote-table-cell-active'
