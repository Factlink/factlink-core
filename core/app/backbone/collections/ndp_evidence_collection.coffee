class window.NDPEvidenceCollection extends Backbone.Factlink.Collection
  initialize: ->
    @on 'change', @sort, @

  comparator: (item) -> - item.get('impact')
