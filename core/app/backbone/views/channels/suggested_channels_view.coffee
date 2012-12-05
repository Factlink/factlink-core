class SuggestedChannelsEmptyView extends Backbone.Marionette.ItemView
  template:
    text: "No suggestions available."

class SuggestedChannelView extends Backbone.Marionette.ItemView
  tagName: 'li'
  template: "channels/suggested_channel"

  events:
    'click' : 'addModel'

  addModelSuccess: (model)->
    console.info "Model succesfully added"

  addModelError: (model) ->
    console.info "suggested_channels_view - error while adding"

  wrapNewModel: (model) ->
    model.clone()

_.extend(SuggestedChannelView.prototype, Backbone.Factlink.AddModelToCollectionMixin)


class window.SuggestedChannelsView extends Backbone.Marionette.CollectionView
  tagName: 'ul'
  itemView: SuggestedChannelView
  className: 'add-to-channel-suggested-channels'

  emptyView: SuggestedChannelsEmptyView

  itemViewOptions: =>
    addToCollection: @options.addToCollection
