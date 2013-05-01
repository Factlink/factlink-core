class window.RelatedChannelView extends Backbone.Marionette.ItemView
  _.extend @prototype, Backbone.Factlink.AddModelToCollectionMixin
  tagName: "li"
  className: "related-channel-container"

  template: "channels/related_channel"
  templateHelpers: ->
    created_by: @model.user().toJSON()

  events:
    'click a.btn' : 'addWrappedModel'

  addModelSuccess: (model)-> @$('a.follow').hide()

  addModelError: (model)-> alert("something went wrong while adding this #{Factlink.Global.t.topic}")

  wrapNewModel: (model) -> new Channel(@model.toJSON())

