class window.RelatedChannelView extends Backbone.Marionette.ItemView
  template: "channels/_related_channel"
  tagName: "li"

  events:
    'click a.btn' : 'addChannel'

  addChannel: ->
    console.info('adding', @model.get('title'), 'to collection', @options.addToCollection)
    @options.addToCollection.add(@model)