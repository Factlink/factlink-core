window.ReactSearchResults = React.createBackboneClass
  displayName: 'ReactSearchResults'
  changeOptions: 'add remove reset sync request'

  _results_per_page: 20  # WARNING: coupling with interactors/search.rb

  _results: ->
    @model().map (model) =>
      switch model.get("the_class")
        when "Annotation"
          fact = new Fact(model.get("the_object"))
          _a ['feed-activity-container search-result',
              href: fact.get('proxy_open_url'),
              rel: 'backbone',
              key: "fact" + fact.id],
            ReactFact
              model: fact
        when "User"
          user = new User(model.get("the_object"))

          _a ['feed-activity-container search-result',
              href: user.link(),
              rel: 'backbone',
              key: "user" + user.id],
            _img ["avatar-image", alt:" ", src: user.avatar_url(32), style: {height: '32px', width: '32px', margin: '0 5px 0 0'}]
            user.get('name')
        else
          console.info "Unknown class of search result: ", model.get("the_class")
          _span()

  render: ->
    _div [],
      _h1 [],
        'Search results for '
        _strong [],
          "\u201C" # left double quote
          @model().query()
          "\u201D" # right double quote
      if @model().length == 0 && !@model().loading()
        _div [],
          "Sorry, your search didn't return any results."
      @_results()
      ReactLoadingIndicator model: @model()
      if @model().length > @_results_per_page
        _div ['search-results-capped-message'],
          "(only showing first #{@_results_per_page} results)"
