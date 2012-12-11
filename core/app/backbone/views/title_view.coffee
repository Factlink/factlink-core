class window.TitleView extends Backbone.View
  initialize: (opts) ->
    @model.on "change", @render, this

  render: ->
    document.title = (@countString() + @factlinkTitle())

  factlinkTitle: ->
    "Factlink — Because the web needs what you know"

  countString: ->
    count = @model.totalUnreadCount()
    if count > 0
      "(" + count + ") "
    else
      ""
