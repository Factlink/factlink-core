class window.BananasView extends Backbone.Marionette.ItemView
  template: 'tour/bananas'

  max_bananas = 5

  initialize: ->
    @collection.on 'reset add remove', => @render()

  templateHelpers: =>
    bananas: if @collection.length < 5
               [1..5-@collection.length]
             else
               []
