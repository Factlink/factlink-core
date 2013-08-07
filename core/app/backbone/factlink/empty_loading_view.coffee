Backbone.Factlink ||= {}

class Backbone.Factlink.LoadingView extends Backbone.Marionette.ItemView
  template: text: '<img class="ajax-loader" src="{{global.ajax_loader_image}}">'

class Backbone.Factlink.EmptyLoadingView extends Backbone.Marionette.Layout
  template: text: '<div class="js-region-empty"></div><div class="js-region-loading"></div>'
  emptyView: null
  loadingView: Backbone.Factlink.LoadingView

  regions:
    emptyRegion:   '.js-region-empty'
    loadingRegion: '.js-region-loading'

  initialize: ->
    unless @collection.loading?
      throw "Cannot show loading view for plain backbone collection"

    @emptyView = @options.emptyView   if @options.emptyView?
    @loadingView   = @options.loadingView if @options.loadingView?
    @listenTo @collection, 'before:fetch reset', @updateLoading, @

  onRender: ->
    @emptyRegion.show   new @emptyView(@options) if @emptyView?
    @loadingRegion.show new @loadingView(@options) if @loadingView?
    @updateLoading()

  updateLoading: ->
    @$('.js-region-loading').toggle @collection.loading()
    @$('.js-region-empty').toggle !@collection.loading()
