class window.FactBottomView extends Backbone.Marionette.ItemView
  className: 'fact-bottom bottom-base pre-ndp-bottom-base'

  template: 'facts/fact_bottom'

  events:
    "click .js-add-to-channel": "showAddToChannel"
    "click .js-start-conversation": "showStartConversation"
    "click .js-open-proxy-link" : "openProxyLink"

  templateHelpers: ->
    formatted_time: ->
      if @friendly_time
        # this is relevant in a channel, a fact is then 'posted'
        # or reposted <time> ago
        "Posted #{@friendly_time} ago"
      else
        @created_by_ago

    show_discussion_link: !@options.hide_discussion_link
    hide_timestamp: !@options.show_timestamp
    show_timestamp_or_fact_url_host: @options.show_timestamp or @model.get('proxy_scroll_url')

    believe_percentage: @model.opinionPercentage('believe')
    disbelieve_percentage: @model.opinionPercentage('disbelieve')

  showAddToChannel: (e) ->
    e.preventDefault()
    e.stopPropagation()

    FactlinkApp.ModalWindowContainer.show new AddToChannelModalWindowView(model: @model)

  showStartConversation: (e) ->
    e.preventDefault()
    e.stopPropagation()

    FactlinkApp.ModalWindowContainer.show new StartConversationModalWindowView(model: @model)

    mp_track "Factlink: Open share modal"


  openProxyLink: (e) ->
    mp_track "Factlink: Open proxy link",
      site_url: @model.get("fact_url")
