class window.Fact extends Backbone.Model
  urlRoot: "/facts"

  getVotes: ->
    @_votes ?= new Votes [], fact: @

  clientLink: -> "/client/facts/#{@id}"

  factUrlHost: ->
    fact_url = @get('site_url')
    return '' unless fact_url

    new Backbone.Factlink.Url(fact_url).host()

  justCreated: ->
    milliseconds_ago = Date.now() - new Date(@get('created_at'))
    minutes_ago = milliseconds_ago/1000/60

    minutes_ago < 5

  share: (provider_names, message=null, options={}) ->
    return unless provider_names.length > 0

    Backbone.ajax _.extend {}, options,
      type: 'post'
      url: "#{@url()}/share"
      data: {provider_names, message}

  friendly_fact_url: ->
    Factlink.Global.core_url + '/f/' + @id

  factUrlTitle: ->
    @get('site_title') || @factUrlHost()
