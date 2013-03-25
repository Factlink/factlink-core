class window.TopTopicView extends Backbone.Marionette.ItemView
  template: "activities/suggested_topic"
  tagName: "li"

  events:
    'click a.btn' : 'addWrappedModel'

  addModelSuccess: (model)->
    @$('a.btn').hide()
    model.change()

  addModelError: (model)->
  	 if Factlink.Global.can_haz.topic_facts
        alert("Something went wrong while creating this #{Factlink.Global.t.topic}")
     else
        alert("Something went wrong while creating this #{Factlink.Global.t.channel}")

  wrapNewModel: (model) -> @model.newChannelForUser(window.currentUser)

_.extend(window.TopTopicView.prototype, Backbone.Factlink.AddModelToCollectionMixin)
