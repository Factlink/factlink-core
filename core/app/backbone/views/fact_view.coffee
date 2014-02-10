ReactFactBody = React.createBackboneClass
  render: ->
    _a ["fact-body-displaystring-clickable",
        href: @model().get('proxy_open_url'),
        target: '_blank'],
      @model().get('displaystring')

ReactFactBase = React.createBackboneClass
  render: ->
    _div ['fact-base'],
      _div ['fact-body'],
        ReactFactBody
          model: @model()

ReactProxyLink = React.createBackboneClass
  _onClick: ->
    mp_track "Factlink: Open proxy link",
      site_url: @model().get("fact_url")

  render: ->
    fact_url_host = @model().factUrlHost()

    _div ['proxy-link-container'],
      _div ['proxy-link-box'],
        _a ["proxy-link",
            href: @model().get("proxy_open_url"),
            target:"_blank",
            onClick: @_onClick],
          _img ["proxy-link-favicon",
                src:"https://www.google.com/s2/u/0/favicons?domain=#{fact_url_host}"],
            @model().factUrlTitle()
      _i ["proxy-link-overflow"]

class window.FactView extends Backbone.Marionette.Layout
  className: "fact-view"
  template: "facts/fact"

  regions:
    factBaseRegion: '.js-fact-base-region'
    linkRegion: '.js-fact-link-region'
    poparrowRegion: '.js-region-poparrow'

  initialize: (opts) ->
    @listenTo @model, "destroy", @close
    @listenTo @model, "change", @render

  onRender: ->
    @factBaseRegion.show new ReactView
      component: ReactFactBase
        model: @model
    @linkRegion.show new ReactView
      component: ReactProxyLink
        model: @model

  remove: -> @$el.fadeOut "fast", -> $(this).remove()
