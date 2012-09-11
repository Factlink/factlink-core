Backbone.Factlink ||= {}
class Backbone.Factlink.CompositeView extends Backbone.Marionette.CompositeView
  appendHtml: (collectionView, itemView) ->
    #TODO: also allow for adding in the middle
    if (collectionView.collection.indexOf(itemView.model) == 0)
      @$(@itemViewContainer).prepend(itemView.el)
    else
      @$(@itemViewContainer).append(itemView.el)