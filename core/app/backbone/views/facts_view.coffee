class window.FactsView extends AutoloadingCompositeView
  tagName: "div"
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
  initialize: (options) ->
    @views = {}
    @addShowHideToggle "loadingIndicator", "div.loading"
    @collection.on "startLoading", @loadingIndicatorOn, this
    @collection.on "stopLoading", @loadingIndicatorOff, this
    @bindTo @model, "change", @showNewPosts, this

  showNewPosts: ->
    if @model.user().get("username") is currentUser.get("username")
      unread_count = parseInt(@model.get("unread_count") or 0, 10)
      @$(".facts-view-more .unread_count").html unread_count
      @$(".facts-view-more").toggle unread_count > 0

  emptyViewOn: ->
    @emptyView = new EmptyFactsView(model: @model)
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

        # HACK this is how backbone marionette stores childviews:
        # dependent on their implementation though
        @children.findByModel(fact).highlight()
        @setCreateFactFormToInitialState()

      error: (data) =>
        alert "Error while adding Factlink to Channel"
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
