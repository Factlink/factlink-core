class window.SuggestedTopicView extends Backbone.Marionette.ItemView
  template: "activities/_suggested_topic"
  tagName: "li"

  events:
    'click a.btn' : 'addWrappedModel'

  addModelSuccess: (model)->
    @$('a.btn').hide()
    model.change()

  addModelError: (model)-> alert('something went wrong while creating this channel')

  wrapNewModel: (model) -> @model.newChannelForUser(window.currentUser)

_.extend(window.SuggestedTopicView.prototype, Backbone.Factlink.AddModelToCollectionMixin)
