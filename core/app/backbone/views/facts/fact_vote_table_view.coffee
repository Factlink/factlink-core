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
    'click .js-button-believes': -> @_votes.clickCurrentUserOpinion 'believes'
    'click .js-button-doubts': -> @_votes.clickCurrentUserOpinion 'doubts'
    'click .js-button-disbelieves': -> @_votes.clickCurrentUserOpinion 'disbelieves'

  initialize: ->
    @_votes = @model.getFactVotes()
    @listenTo @_votes, 'change:current_user_opinion', @_updateActiveCell
    @listenTo @_votes, 'sync', -> @collection.fetch()

    @collection = @model.getVotes()
    @collection.fetch()

  appendHtml: (collectionView, itemView, index) ->
    if itemView.model.get('type') == 'believes'
      @ui.avatarsBelievesRegion.append itemView.el
    if itemView.model.get('type') == 'disbelieves'
      @ui.avatarsDisbelievesRegion.append itemView.el
    if itemView.model.get('type') == 'doubts'
      @ui.avatarsDoubtsRegion.append itemView.el

  onRender: ->
    @_updateActiveCell()

  _updateActiveCell: ->
    opinion = @_votes.get('current_user_opinion')
    @$('.fact-vote-table-cell-active').removeClass 'fact-vote-table-cell-active'
    @$(".js-cell-#{opinion}").addClass 'fact-vote-table-cell-active'
