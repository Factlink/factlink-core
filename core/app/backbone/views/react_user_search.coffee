window.ReactUserSearch = React.createBackboneClass
  displayName: 'ReactUserSearch'

  render: ->
    _div [],
      _a [rel:"backbone", href:@model().link()],
        _img ["feed-activity-user-avatar image-30px", alt:" ", src: @model().avatar_url(30)]
      _strong ['search-user-name'],
        _a [rel:"backbone", href:@model().link()],
          @model().get('name')
