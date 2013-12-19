class OpinionatorsAvatarView extends Backbone.Marionette.Layout
  tagName: 'span'
  className: 'opinionators-avatar'
  template: 'opinionators/avatar'

  onRender: ->
    UserPopoverContentView.makeTooltip @, @model

class window.OpinionatorsAvatarsView extends Backbone.Marionette.CompositeView
  tagName: 'span'
  className: 'opinionators-avatars'
  template: "opinionators/avatars"
  itemView: OpinionatorsAvatarView

  itemViewContainer: ".js-opinionators-avatars-collection"
