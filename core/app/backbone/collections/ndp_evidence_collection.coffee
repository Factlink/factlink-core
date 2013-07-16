class window.NDPEvidenceCollection extends Backbone.Collection
  initialize: ->
    @on 'change', @sort, @

  comparator: (item) -> - item.get('impact')
