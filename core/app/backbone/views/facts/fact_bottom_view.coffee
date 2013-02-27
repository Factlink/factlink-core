# TODO: check if formatted_time logic is needed at all

class window.FactBottomView extends Backbone.Marionette.ItemView
  className: 'fact-bottom bottom-base'

  template: 'facts/fact_bottom'

  events:
    "click .js-add-to-channel": "showAddToChannel"
    "click .js-start-conversation": "showStartConversation"
    "click .js-open-proxy-link" : "openProxyLink"

  templateHelpers: ->
    fact_url_host: ->
      new Backbone.Factlink.Url(@fact_url).host() if @fact_url?
    formatted_time: ->
      if @friendly_time
        "#{@post_action} #{@friendly_time} ago"
      else
        @created_by_ago
    believe_percentage: @model.opinionPercentage('believe')
    disbelieve_percentage: @model.opinionPercentage('disbelieve')

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
        FactlinkApp.Modal.close()

    FactlinkApp.Modal.show 'Repost Factlink',
      new AddToChannelModalView(collection: collection, model: @model)

    mp_track "Factlink: Open repost modal"

  showStartConversation: (e) ->
    e.preventDefault()
    e.stopPropagation()

    FactlinkApp.Modal.show 'Send a message',
      new StartConversationView(model: @model)

    mp_track "Factlink: Open share modal"


  openProxyLink: (e) ->
    mp_track "Factlink: Open proxy link",
      site_url: @model.get("fact_url")
