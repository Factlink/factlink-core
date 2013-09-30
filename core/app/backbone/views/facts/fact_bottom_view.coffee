class window.FactBottomView extends Backbone.Marionette.ItemView
  className: 'fact-bottom'

  template: 'facts/fact_bottom'

  events:
    "click .js-add-to-channel": "showAddToChannel"
    "click .js-start-conversation": "showStartConversation"
    "click .js-open-proxy-link" : "openProxyLink"
    "click .js-arguments-link": "openDiscussionModal"

  templateHelpers: ->
    formatted_time: ->
      if @friendly_time
        # this is relevant in a channel, a fact is then 'posted'
        # or reposted <time> ago
        "Posted #{@friendly_time} ago"
      else
        @created_by_ago

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

  openDiscussionModal: (e) ->
    e.preventDefault()

    FactlinkApp.DiscussionModalOnFrontend.openDiscussion @model.clone()
