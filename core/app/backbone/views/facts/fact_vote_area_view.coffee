ReactOpinionatorsAvatar = React.createBackboneClass
  render: ->
    R.span className: 'opinionators-avatar',
      R.a
        href: @model().get('username')
        rel:"backbone"
        class:"popover-link js-user-link opinionators-avatar-link"

        R.img
          src: @model().avatar_url(24)
          class:"image-24px opinionators-avatar-image"

class OpinionatorsAvatarView extends Backbone.Marionette.Layout

  onRender: ->
    UserPopoverContentView.makeTooltip @, @model.user()


class window.FactVoteTableView extends Backbone.Marionette.CompositeView
  tagName: 'div'
  className: 'fact-vote-area'
  template: 'facts/fact_vote_area'
  itemView: ReactView

  itemViewOptions: (vote)=>
    component: ReactOpinionatorsAvatar
      model: vote.user()

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
    @$(".fact-vote-button-#{opinion}").addClass 'fact-vote-button-active'
