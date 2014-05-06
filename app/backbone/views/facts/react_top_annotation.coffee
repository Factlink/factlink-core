ReactTopAnnotationFactlink = React.createBackboneClass
  displayName: 'ReactTopAnnotationFactlink'

  render: ->
    _div ['top-annotation'],
      if @model().get('displaystring')
        _div ['top-annotation-text'],
          ReactCollapsedText
            text: @model().get('displaystring')
            size: 150
      else
        _div ["loading-indicator-centered"],
          ReactLoadingIndicator()


ReactTopAnnotationKennisland = React.createBackboneClass
  displayName: 'ReactTopAnnotationKennisland'

  render: ->
    _div ['top-annotation'],
      if @model().get('html_content')
        _span [dangerouslySetInnerHTML: {__html: @model().get('html_content')}]
      else
        _div ["loading-indicator-centered"],
          ReactLoadingIndicator()

if window.is_kennisland
  window.ReactTopAnnotation = ReactTopAnnotationKennisland
else
  window.ReactTopAnnotation = ReactTopAnnotationFactlink
