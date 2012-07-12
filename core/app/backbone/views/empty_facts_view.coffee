class window.EmptyFactsView extends Backbone.Marionette.ItemView
  template: 'channels/no_facts'

  initialize: ->
    if @model.get('is_normal')
      @relatedChannelsView = new RelatedChannelsView(model: @model)

  onRender: ->
    if @relatedChannelsView
      @relatedChannelsView.render()
      @$('.related-channels').html(@relatedChannelsView.el)

  onClose: -> @relatedChannelsView?.close()
