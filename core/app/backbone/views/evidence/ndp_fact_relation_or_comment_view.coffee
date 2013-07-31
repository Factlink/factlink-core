class NDPCommentView extends Backbone.Marionette.Layout
  template:
    text: """
      {{content}}
    """

class window.NDPFactRelationOrCommentView extends Backbone.Marionette.Layout
  className: 'ndp-fact-relation-or-comment'
  template:
    text:
      """
        <div class="ndp-fact-relation-or-comment-content js-content-region"></div>
      """

  regions:
    contentRegion: '.js-content-region'

  onRender: ->
    if @model instanceof Comment
      @contentRegion.show new NDPCommentView model: @model
    else
      @contentRegion.show new TextView model: new Backbone.Model text: 'blaat'

