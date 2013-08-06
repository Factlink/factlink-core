class SuggestedTopicView extends Backbone.Marionette.ItemView
  _.extend @prototype, Backbone.Factlink.AddModelToCollectionMixin

  tagName: 'li'
  template: 'channels/suggested_topic'

  events:
    'click' : 'clickAdd'

  clickAdd: ->
    @model.withCurrentOrCreatedChannelFor currentUser,
      success: (channel) =>
        @addModel channel
      error: =>
        console.info 'Adding the suggested topic failed'

  addModelSuccess: (model)->
    console.info 'Model succesfully added'

  addModelError: (model) ->
    console.info "SuggestedTopicView - error while adding #{@name}"



class SuggestedTopicsView extends Backbone.Marionette.CollectionView
  tagName: 'ul'
  itemView: SuggestedTopicView
  className: 'add-to-channel-suggested-topics'

  itemViewOptions: =>
    addToCollection: @options.addToCollection


class window.FilteredSuggestedTopicsView extends Backbone.Marionette.Layout
  template: 'channels/filtered_suggested_topics'

  ui:
    loadingIndicator: '.js-suggested-topics-loading-indicator'
    content: '.js-content'

  regions:
    suggestedTopicsRegion: '.js-region-suggested-topics'

  initialize: (options) ->
    utils = new CollectionUtils(this)
    @filtered_collection = utils.difference(new Backbone.Collection(),
                                                  'slug_title',
                                                  @collection,
                                                  @options.addToCollection)

    @bindTo @filtered_collection, 'add remove reset change', @updateVisibilities, @

  onRender: ->
    @suggestedTopicsRegion.show new SuggestedTopicsView
      collection: @filtered_collection
      addToCollection: @options.addToCollection

    @updateVisibilities()

    @collection.waitForFetch =>
      @updateVisibilities()

  updateVisibilities: ->
    @ui.loadingIndicator.toggle @collection.loading()
    @ui.content.toggle @filtered_collection.length > 0
