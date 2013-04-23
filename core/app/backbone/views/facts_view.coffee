class window.FactsView extends AutoloadingCompositeView
  className: "facts-view"
  itemViewContainer: ".facts"
  itemView: FactView

  events:
    "submit #create_fact_for_channel": "createFact"
    "focus #create_fact_for_channel textarea": "openCreateFactForm"
    "click #create_fact_for_channel .create_factlink .close": "closeCreateFactForm"
    "click #create_fact_for_channel": "focusCreateFactlink"
    "click #create_fact_for_channel .input-box": "focusField"

  template: "channels/facts"

  templateHelpers: =>
    can_add_fact: @collection.canAddFact()

  initialize: (options) ->
    @addShowHideToggle "loadingIndicator", "div.loading"
    @collection.on "startLoading", @loadingIndicatorOn, this
    @collection.on "stopLoading", @loadingIndicatorOff, this

  emptyViewOn: ->
    @emptyView = new EmptyTopicView
    @$("div.no_facts").html @emptyView.render().el

  emptyViewOff: ->
    @emptyView.close()
    delete @emptyView

  createFact: (e) ->
    e.preventDefault()

    $form = @$("form")
    $textarea = $form.find("textarea[name=fact]")
    $submit = $form.find("button")
    $form.find(":input").prop "disabled", true
    $.ajax
      url: @collection.url()
      type: "POST"
      data:
        displaystring: $textarea.val()

      success: (data) =>
        fact = new Fact(data)
        @collection.unshift fact

        @children.findByModel(fact).highlight()
        @setCreateFactFormToInitialState()

      error: (data) =>
        alert "Error while adding Factlink to this #{Factlink.Global.t.topic}"
        @setCreateFactFormToInitialState()

  setCreateFactFormToInitialState: ->
    @$("form").find(":input").val("").prop "disabled", false
    @closeCreateFactForm()

  focusField: (e) ->
    $(e.target).closest("input-box").find(":input").focus()

  openCreateFactForm: ->
    @$("form").addClass "active"

  closeCreateFactForm: (e) ->
    @$("form").removeClass("active").filter(":input").val ""
    e?.stopPropagation()

  focusCreateFactlink: (e) ->
    $target = $(e.target)
    if not $target.is(":input")
      $(e.target).closest("form").find("textarea").focus()

_.extend window.FactsView.prototype, ToggleMixin
