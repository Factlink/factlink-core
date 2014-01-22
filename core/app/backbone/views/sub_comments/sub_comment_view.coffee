class ReactView extends Backbone.View
  render: ->
    React.renderComponent(@options.component, @el)

reactShow = (region, component) ->
  region.show new ReactView(component: component)

r = React.DOM
ReactSubComment = React.createBackboneClass
  render: ->
    r.span {},
      @getModel().get('formatted_comment_content')

class window.SubCommentView extends Backbone.Marionette.Layout
  template: 'sub_comments/sub_comment'

  regions:
    deleteRegion: '.js-delete-region'
    contentRegion: '.js-content-region'

  initialize: ->
    @listenTo @model, 'change', @render

  templateHelpers: =>
    showDelete: @model.can_destroy()

  onRender: ->
    if @model.can_destroy()
      @_deleteButtonView = new DeleteButtonView model: @model
      @listenTo @_deleteButtonView, 'delete', -> @model.destroy wait: true
      @deleteRegion.show @_deleteButtonView

    reactShow @contentRegion, ReactSubComment(model: @model)
