class window.TopTopicView extends Backbone.Marionette.ItemView
  template: "activities/suggested_topic"
  tagName: "li"

  events:
    'click a.btn' : 'addWrappedModel'

  addModelSuccess: (model)->
    @$('a.btn').hide()
    model.change()

  addModelError: (model)-> alert('something went wrong while creating this channel')

  wrapNewModel: (model) -> @model.newChannelForUser(window.currentUser)

_.extend(window.TopTopicView.prototype, Backbone.Factlink.AddModelToCollectionMixin)
