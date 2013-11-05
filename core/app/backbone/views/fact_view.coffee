#= require ./facts/fact_base_view

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
    @factBaseRegion.show new FactBaseView(model: @model)

    if @model.get('proxy_scroll_url')
      @linkRegion.show new FactProxyLinkView model: @model

  remove: -> @$el.fadeOut "fast", -> $(this).remove()
