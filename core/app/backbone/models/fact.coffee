class window.Fact extends Backbone.Model
  urlRoot: "/facts"

  getVotes: ->
    @_votes ?= new Votes [], fact: @

  clientLink: -> "/client/facts/#{@id}"

  can_destroy: -> false

  factUrlHost: ->
    fact_url = @get('fact_url')
    return '' unless fact_url

    new Backbone.Factlink.Url(fact_url).host()

  justCreated: ->
    milliseconds_ago = Date.now() - new Date(@get('created_at'))
    minutes_ago = milliseconds_ago/1000/60

    minutes_ago < 5

  share: (provider_names, message=null, options={}) ->
    Backbone.ajax _.extend {}, options,
      type: 'post'
      url: "#{@url()}/share"
      data: {provider_names, message}

  friendly_fact_url: ->
    Factlink.Global.core_url + '/f/' + @id

  toJSON: ->
    _.extend super(),
      can_destroy: @can_destroy()
      fact_url_host: @factUrlHost()
      fact_url_title: @get('fact_title') || @factUrlHost()
