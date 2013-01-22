class window.RelatedChannelView extends Backbone.Marionette.ItemView
  template: "channels/_related_channel"
  tagName: "li"
  className: "related-channel-container"

  events:
    'click a.btn' : 'addWrappedModel'

  addModelSuccess: (model)-> @$('a.follow').hide()

  addModelError: (model)-> alert('something went wrong while adding this channel')

  wrapNewModel: (model) -> new Channel(@model.toJSON())

_.extend(window.RelatedChannelView.prototype, Backbone.Factlink.AddModelToCollectionMixin)
