Backbone.Factlink ||= {}

Backbone.Factlink.Trunk8MoreLessMixin =
  trunk8Init: (numberOfLines) ->
    @_trunk8Lines = numberOfLines

    @on 'render', @trunk8Render, @

    @$el.delegate 'a.more', 'click', => @trunk8Show()
    @$el.delegate 'a.less', 'click', => @trunk8Hide()

  trunk8Render: ->
    sometimeWhen(
      => @$el.is ":visible"
      ,
      => @trunk8Text()
    )

  trunk8Text: ->
    @$('.js-content').trunk8
      fill: " <a class=\"more\">(more)</a>"
      lines: @_trunk8Lines

  trunk8Show: (e) ->
    console.log 'hihihihi'
    @$('.js-content').trunk8 lines: 199
    @$('.less').show()
    e.stopPropagation()

  trunk8Hide: (e) ->
    @$('.js-content').trunk8 lines: @_trunk8Lines
    @$('.less').hide()
    e.stopPropagation()
