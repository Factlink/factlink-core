class window.AutoCompletedChannelView extends Backbone.Marionette.ItemView
  tagName: "li"

  triggers:
    "mouseenter": "requestActivate",
    "mouseleave": "requestDeActivate"

  template: "channels/_auto_completed_channel"

  initialize: ->
    @queryRegex = new RegExp(@options.query, "gi")

    @on 'activate', => @activate()
    @on 'deactivate', => @deactivate()


  templateHelpers: ->
    view = this
    return { highlightedTitle: -> htmlEscape(@title).replace(view.queryRegex, "<em>$&</em>")}

  onRender: ->
    if @model.get('user_channel' )
      @$el.addClass('user-channel')

  deactivate: -> @$el.removeClass 'active'
  activate: ->
    @$el.addClass 'active'
    @scrollIntoView()

  scrollIntoView: ->
    container = @$el.closest("ul")[0]
    unless @isScrolledIntoView(@el) and @isInsideContainerBoundaries(@el, container)
      if (container.scrollHeight > container.clientHeight)
        @el.scrollIntoView(false)

  isScrolledIntoView: (elem)->
    docViewTop = $(window).scrollTop();
    docViewBottom = docViewTop + $(window).height();

    elemTop = $(elem).offset().top;
    elemBottom = elemTop + $(elem).height();

    return ((elemBottom <= docViewBottom) && (elemTop >= docViewTop));

  isInsideContainerBoundaries: (elem, container) ->
    docViewTop = $(container).offset().top;
    docViewBottom = docViewTop + $(container).height();

    elemTop = $(elem).offset().top;
    elemBottom = elemTop + $(elem).height();

    return ((elemBottom <= docViewBottom) && (elemTop >= docViewTop));
