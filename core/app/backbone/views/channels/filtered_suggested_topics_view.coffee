class SuggestedTopicView extends Backbone.Marionette.ItemView
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

_.extend(SuggestedTopicView.prototype, Backbone.Factlink.AddModelToCollectionMixin)


class SuggestedTopicsView extends Backbone.Marionette.CollectionView
  tagName: 'ul'
  itemView: SuggestedTopicView
  className: 'add-to-channel-suggested-topics'

  itemViewOptions: =>
    addToCollection: @options.addToCollection


class window.FilteredSuggestedTopicsView extends Backbone.Marionette.Layout
  template: 'channels/filtered_suggested_topics'

  regions:
    suggestedTopicsRegion: '.js-suggested-topics-region'

  initialize: (options) ->
    utils = new CollectionUtils(this)
    @collection = utils.difference(new Backbone.Collection(),
                                                  'slug_title',
                                                  @collection,
                                                  @options.addToCollection)

    @bindTo @collection, 'add remove reset change', @updateTitle, @

  onRender: ->
    @suggestedTopicsRegion.show new SuggestedTopicsView
      collection: @collection
      addToCollection: @options.addToCollection

    @updateTitle()

  updateTitle: ->
    @$('.js-suggestions-title').toggle @collection.length > 0
