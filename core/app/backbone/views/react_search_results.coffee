window.ReactSearchResults = React.createBackboneClass
  displayName: 'ReactSearchResults'

  _results_per_page: 20  # WARNING: coupling with search_controller.rb

  render: ->
    _div [],
      _h1 [],
        'Search results for '
        _strong [],
          "\u201C" # left double quote
          @model().query()
          "\u201D" # right double quote
      ReactLoadingIndicator {model: @model()},
        _div [],
          "Sorry, your search didn't return any results"
      @_results()
      if @model().length > @_results_per_page
        _div ['search-results-capped-message'],
          "(only showing first #{@_results_per_page} results)"

  _results: ->
    @model().map (model) =>
      switch model.get("the_class")
        when "Annotation"
          fact = new Fact(model.get("the_object"))
          _a ['feed-activity-container search-result', href: fact.get('proxy_open_url')],
            ReactFact
              model: fact
        when "User"
          user = new User(model.get("the_object"))

          _a ['feed-activity-container search-result', href: user.link(), rel: 'backbone'],
            _div ['feed-activity-heading'],
              _img ["avatar-image", alt:" ", src: user.avatar_url(32), style: {height: '32px', width: '32px', margin: '0 5px 0 0'}]
              user.get('name')
        else
          console.info "Unknown class of search result: ", model.get("the_class")
          _span()
