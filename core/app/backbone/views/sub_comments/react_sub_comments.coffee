window.ReactLoadingIndicator = React.createClass
  render: ->
    R.img
      className: 'ajax-loader'
      src: Factlink.Global.ajax_loader_image

window.ReactSubComments = React.createBackboneClass
  getInitialState: ->
    loading: true

  componentDidMount: ->
    @model().fetch
      success: => @setState loading: false
    @setState loading: true

  render: ->
    if @model().size() == 0 && @state.loading
      ReactLoadingIndicator()
    else
      R.div className: 'sub-comments',
        @model().map (sub_comment) =>
          ReactSubComment(model: sub_comment)
        ReactSubCommentsAdd(addToCollection: @model())
