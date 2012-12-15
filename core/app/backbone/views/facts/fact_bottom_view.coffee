# When fixing modals, remove this entire view
class WrapperView extends Backbone.Marionette.Layout
  template:
    text: """
      <div class="modal">
        <div class="modal-header">
          <button type="button" class="close close-popup">&times;</button>
          <h3>{{title}}</h3>
        </div>
        <div class="modal-body">
        </div>
      </div>
      <div class="transparent-layer close-popup"></div>
    """

  events:
    "click .close-popup": "close"
    "click": "stopPropagation"

  regions:
    modalRegion: '.modal-body'

  templateHelpers: =>
    title: @options.title

  onRender: ->
    @modalRegion.show @options.content_view
    @$('.modal').show()
    @$('.transparent-layer').show()

  stopPropagation: (e) ->
    e.stopPropagation()

# When fixing modals, we *probably* don't need a Layout any more
class window.FactBottomView extends Backbone.Marionette.Layout
  template: "facts/fact_bottom"

  events:
    "click .js-add-to-channel": "showAddToChannel",
    "click .js-start-conversation": "showStartConversation"

  # When fixing modals, remove this
  regions:
    modalRegion: ".js-modal-region"

  templateHelpers: ->
    fact_url_host: ->
      if @fact_url?
        url = document.createElement('a')
        url.href = @fact_url

        url.host

  showAddToChannel: (e) ->
    e.preventDefault()
    e.stopPropagation()

    collection = @model.getOwnContainingChannels(this)
    collection.on "add", (channel) =>
      @model.addToChannel channel, {}

    collection.on "remove", (channel) =>
      @model.removeFromChannel channel, {}
      if window.currentChannel and currentChannel.get("id") is channel.get("id")
        @model.collection.remove @model
        # When fixing modals, reinstate this
        # FactlinkApp.Modal.close()

    # When fixing modals, reinstate this
    # FactlinkApp.Modal.show 'Repost Factlink',
    #   new AddToChannelModalView(collection: collection, model: @model)
    @modalRegion.show new WrapperView
      title: 'Repost Factlink'
      content_view: new AddToChannelModalView(collection: collection, model: @model)

  showStartConversation: (e) ->
    e.preventDefault()
    e.stopPropagation()

    # When fixing modals, reinstate this
    # FactlinkApp.Modal.show 'Send a message',
    #   new StartConversationView(model: @model)
    @modalRegion.show new WrapperView
      title: 'Send a message'
      content_view: new StartConversationView(model: @model)
