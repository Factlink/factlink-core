class OpinionatorsAvatarView extends Backbone.Marionette.Layout
  tagName: 'span'
  className: 'opinionators-avatar'
  template: 'opinionators/avatar'

  onRender: ->
    UserPopoverContentView.makeTooltip @, @model

class window.OpinionatorsAvatarsView extends Backbone.Marionette.CollectionView
  tagName: 'span'
  className: 'opinionators-avatars'
  itemView: OpinionatorsAvatarView
