class window.FactRelationPreviewView extends Backbone.Marionette.Layout
  template: 'fact_relations/preview'

  regions:
    factBaseRegion: '.fact-base-region'

  events:
    'click .js-cancel': 'onCancel'
    'click .js-post': 'onPost'

  onRender: ->
    @factBaseRegion.show new FactBaseView
      model: @model

  onCancel: -> @trigger 'cancel'

  onPost: -> @trigger 'createFactRelation', @model
