class SuggestedTopicsEmptyView extends Backbone.Marionette.ItemView
  template:
    text: "No suggestions available."

class SuggestedSiteTopicView extends Backbone.Marionette.ItemView
  tagName: 'li'
  template: "channels/suggested_channel"

  events:
    'click' : 'clickAdd'

  clickAdd: ->
    @model.withCurrentOrCreatedChannelFor currentUser,
      success: (channel) =>
        @addModel channel
      error: =>
        console.info 'Adding the suggested topic failed'

  addModelSuccess: (model)->
    console.info "Model succesfully added"

  addModelError: (model) ->
    console.info "SuggestedSiteTopicView - error while adding"

_.extend(SuggestedSiteTopicView.prototype, Backbone.Factlink.AddModelToCollectionMixin)


class window.SuggestedSiteTopicsView extends Backbone.Marionette.CollectionView
  tagName: 'ul'
  itemView: SuggestedSiteTopicView
  className: 'add-to-channel-suggested-channels'

  emptyView: SuggestedTopicsEmptyView

  itemViewOptions: =>
    addToCollection: @options.addToCollection
