Backbone.Factlink ||= {}

Backbone.Factlink.Trunk8MoreLessMixin =
  trunk8Init: (numberOfLines, contentSelector, lessSelector) ->
    @_trunk8Lines = numberOfLines
    @_trunk8ContentSelector = contentSelector
    @_trunk8LessSelector = lessSelector

    @on 'render', @trunk8Render, @

    @$el.delegate 'a.trunk8-more', 'click', => @trunk8Show()
    @$el.delegate @_trunk8LessSelector, 'click', => @trunk8Hide()

  trunk8Render: ->
    sometimeWhen(
      => @$el.is ":visible"
      ,
      => @trunk8Text()
    )

  trunk8Text: ->
    @$(@_trunk8ContentSelector).trunk8
      fill: " <a class=\"trunk8-more\">(more)</a>"
      lines: @_trunk8Lines

  trunk8Show: (e) ->
    @$(@_trunk8ContentSelector).trunk8 lines: 199
    @$(@_trunk8LessSelector).show()
    e.stopPropagation()

  trunk8Hide: (e) ->
    @$(@_trunk8ContentSelector).trunk8 lines: @_trunk8Lines
    @$(@_trunk8LessSelector).hide()
    e.stopPropagation()
