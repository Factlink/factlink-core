class SuggestedSiteTopicView extends Backbone.Marionette.ItemView
  tagName: 'li'
  template: 'channels/suggested_site_topic'

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
    console.info "SuggestedSiteTopicView - error while adding #{@name}"

_.extend(SuggestedSiteTopicView.prototype, Backbone.Factlink.AddModelToCollectionMixin)


class SuggestedSiteTopicsView extends Backbone.Marionette.CollectionView
  tagName: 'ul'
  itemView: SuggestedSiteTopicView
  className: 'add-to-channel-suggested-site-topics'

  itemViewOptions: =>
    addToCollection: @options.addToCollection


class window.FilteredSuggestedSiteTopicsView extends Backbone.Marionette.Layout
  template: 'channels/filtered_suggested_site_topics'

  regions:
    suggestedSiteTopicsRegion: '.js-suggested-site-topics-region'

  initialize: (options) ->
    suggested_topics = new SuggestedSiteTopics([], site_url: @options.site_url)
    suggested_topics.fetch()

    utils = new CollectionUtils(this)
    @collection = utils.difference(new Backbone.Collection(),
                                                  'slug_title',
                                                  suggested_topics,
                                                  @options.addToCollection)

    @bindTo @collection, 'add remove reset change', @updateTitle, @

  onRender: ->
    @suggestedSiteTopicsRegion.show new SuggestedSiteTopicsView
      collection: @collection
      addToCollection: @options.addToCollection

    @updateTitle()

  updateTitle: ->
    @$('.js-suggestions-title').toggle @collection.length > 0
