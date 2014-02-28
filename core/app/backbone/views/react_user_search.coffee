window.ReactUserSearch = React.createBackboneClass
  displayName: 'ReactUserSearch'

  render: ->
    _div ['feed-activity-heading'],
      _a [' feed-activity-username', rel:"backbone", href:@model().link()],
        _img ["avatar-image", alt:" ", src: @model().avatar_url(32), style: {height: '32px', width: '32px', margin: '0 5px 0 0'}]
        @model().get('name')
