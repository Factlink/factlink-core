class window.Fact extends Backbone.Model
  urlRoot: "/facts"

  getOpinionators: ->
    @_opinionators ?= new Opinionators [], fact: @

  comments: ->
    @_comments ?= new Comments null, fact: @

  clientLink: -> "/client/facts/#{@id}"

  factUrlHost: ->
    fact_url = @get('site_url')
    return '' unless fact_url

    new Backbone.Factlink.Url(fact_url).host()

  justCreated: ->
    milliseconds_ago = Date.now() - new Date(@get('created_at'))
    minutes_ago = milliseconds_ago/1000/60

    minutes_ago < 5

  share: (providers, message=null) ->
    provider_names = []
    provider_names.push 'twitter' if providers.twitter
    provider_names.push 'facebook' if providers.facebook
    return unless provider_names.length > 0

    Backbone.ajax
      type: 'post'
      url: "#{@url()}/share"
      data: {provider_names, message}
      error: ->
        FactlinkApp.NotificationCenter.error "Error when sharing"

  friendly_fact_url: ->
    Factlink.Global.core_url + '/f/' + @id

  factUrlTitle: ->
    @get('site_title') || @factUrlHost()
