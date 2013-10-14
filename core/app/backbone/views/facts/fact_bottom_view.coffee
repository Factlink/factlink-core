class window.FactBottomView extends Backbone.Marionette.ItemView
  className: 'fact-bottom'

  template: 'facts/fact_bottom'

  events:
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

  openProxyLink: (e) ->
    mp_track "Factlink: Open proxy link",
      site_url: @model.get("fact_url")

  openDiscussionModal: (e) ->
    e.preventDefault()

    if e.metaKey or e.ctrlKey or e.altKey
      window.open @model.get('url'), "_blank"
    else
      FactlinkApp.DiscussionModalOnFrontend.openDiscussion @model.clone()
