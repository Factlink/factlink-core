class window.Fact extends Backbone.Model
  urlRoot: "/api/beta/annotations"

  getOpinionators: ->
    @_opinionators ?= new Opinionators [], fact: @

  comments: ->
    @_comments ?= new Comments null, fact: @

  factUrlHost: ->
    fact_url = @get('site_url')
    return '' unless fact_url

    new Backbone.Factlink.Url(fact_url).host()

  friendly_fact_url: ->
    Factlink.Global.core_url + '/f/' + @id

  factUrlTitle: ->
    @get('site_title') || @factUrlHost()

  # TODO: Save a fact in the backend when submitting a comment
  saveUnlessNew: (callback) ->
    return callback() unless @isNew()

    @save {}, success: callback

  sharingUrl: ->
    return "http://example.org" if Factlink.Global.environment == 'development'

    @get('proxy_open_url')
