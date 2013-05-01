class window.TopTopicView extends Backbone.Marionette.ItemView
  _.extend @prototype, Backbone.Factlink.AddModelToCollectionMixin
  template: "activities/suggested_topic"
  tagName: "li"

  events:
    'click a.btn' : 'addWrappedModel'

  addModelSuccess: (model)->
    @$('a.btn').hide()
    model.change()

  addModelError: (model)->
        alert("Something went wrong while creating this #{Factlink.Global.t.topic}")
   
  wrapNewModel: (model) -> @model.newChannelForUser(window.currentUser)

