class window.RelatedChannelView extends Backbone.Marionette.ItemView
  tagName: "li"
  className: "related-channel-container"

  template: "channels/related_channel"
  templateHelpers: ->
    created_by: @model.user().toJSON()

  events:
    'click a.btn' : 'addWrappedModel'

  addModelSuccess: (model)-> @$('a.follow').hide()

  addModelError: (model)-> alert('something went wrong while adding this channel')

  wrapNewModel: (model) -> new Channel(@model.toJSON())

_.extend(window.RelatedChannelView.prototype, Backbone.Factlink.AddModelToCollectionMixin)
