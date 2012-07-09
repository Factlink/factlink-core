AddModelToCollectionMixin =
  addModel: ->
    console.info('adding', @model.get('title'), 'to collection', @options.addToCollection)
    if @wrapNewModel
      model = @wrapNewModel(@model)
    else
      model = @model
    @options.addToCollection.add(model)
    model.save({},{
      success: =>
        if @addModelSuccess
          @addModelSuccess(model)
      error: =>
        @options.addToCollection.remove(model)
        if addModelError
          @addModelError(model)
    })

class window.RelatedChannelView extends Backbone.Marionette.ItemView
  template: "channels/_related_channel"
  tagName: "li"

  events:
    'click a.btn' : 'addModel'

  addModelSuccess: (model)-> @$('a.follow').hide()

  addModelError: (model)-> alert('something went wrong while adding this channel')

  wrapNewModel: (model) -> new Channel(@model.toJSON())

_.extend(window.RelatedChannelView.prototype, AddModelToCollectionMixin)