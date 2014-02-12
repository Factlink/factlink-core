window.ReactUserSearch = React.createBackboneClass
  displayName: 'ReactUserSearch'

  render: ->
    _div ["user-search-result search-result"],
      _a [rel:"backbone", href:@model().link()],
        _img ["image-32px", alt:" ", src: @model().avatar_url(32)]
      " "
      _strong [],
        _a [rel:"backbone", href:@model().link()],
          @model().get('name')
