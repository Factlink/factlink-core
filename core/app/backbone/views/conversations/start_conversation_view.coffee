class AutoCompleteAddedUserView extends Backbone.Marionette.ItemView
  tagName: "li"

  triggers:
    "click a.icon-remove": "remove"

  template: "channels/_auto_complete_added_user"

class window.AutoCompleteAddedUsersView extends Backbone.Marionette.CollectionView
  itemView: AutoCompleteAddedUserView
  tagName: 'ul'
  className: 'added_channels'

  initialize: ->
    @on "itemview:remove", (childView, msg) => @collection.remove childView.model


class AutoCompleteUserView extends AutoCompletedChannelView
  templateHelpers: ->
    view = this

    highlightedTitle: -> htmlEscape(@username).replace(view.queryRegex, "<em>$&</em>")

  onRender: ->

class window.AutoCompletesUserView extends Backbone.Factlink.SteppableView
  template: "channels/auto_completes"

  itemViewContainer: 'ul.existing-container'
  itemView: AutoCompleteUserView

  className: 'auto_complete'

  itemViewOptions: => query: @model.get('text')

  initialize: -> @on 'composite:collection:rendered', => @setActiveView 0

  onRender: -> @$(@itemViewContainer).preventScrollPropagation()

  showEmptyView: -> @$el.hide()
  closeEmptyView: -> @$el.show()

class window.AutoCompleteUsersView extends AutoCompleteSearchView
  tagName: "div"
  className: "auto-complete-users"
  events:
    "click div.auto_complete": "addCurrent"

  regions:
    'added_channels': 'div.added_channels_container'
    'auto_completes': 'div.auto_complete_container'
    'input': 'div.fake-input'

  template: "users/autocomplete/_auto_complete"

  auto_complete_search_view_options:
    filter_on: 'username'
    results_view: AutoCompletedAddedChannelsView
    search_collection: UserSearchResults
    auto_completes_view: AutoCompletesUserView

  initialize: ->
    @initialize_child_views @auto_complete_search_view_options
    @_results_view.on "itemview:remove",  (childView, msg) =>
      @trigger 'removeChannel', childView.model

  onRender: ->
    @added_channels.show @_results_view
    @auto_completes.show @_auto_completes_view
    @input.show @_text_input_view

  addCurrent: ->
    user = @_auto_completes_view.currentActiveModel()
    @collection.add user

  disable: ->
    @$el.addClass("disabled")
    @_text_input_view.disable()

  enable: ->
    @$el.removeClass("disabled")
    @_text_input_view.enable()


class window.StartConversationView extends Backbone.Marionette.Layout
  className: "start-conversation-form"
  events:
    "click .submit": 'submit'

  regions:
    'recipients_container': 'div.recipients-container'

  template: 'conversations/start_conversation'

  initialize: ->
    @recipients = new Users
    @auto_complete_view = new AutoCompleteUsersView(collection: @recipients)

  onRender: ->
    @recipients_container.show @auto_complete_view

  submit: ->
    recipients = _union(@recipients.pluck('username'), [currentUser.get('username')])
    console.log(recipients)

    conversation = new Conversation(
      recipients: recipients
      sender: currentUser.get('username')
      content: @$('.text').val()
      fact_id: @model.id
    )

    @showAlert null
    @disableSubmit()
    conversation.save [],
      success: =>
        @showAlert 'success'
        @enableSubmit()
        @clearForm()

      error: (model, response) =>
        if response.responseText in ['user_not_found']
          @showAlert response.responseText
        else
          @showAlert 'error'
        @enableSubmit()

  enableSubmit:  -> @$('.submit').prop('disabled',false).val('Send')
  disableSubmit: -> @$('.submit').prop('disabled',true ).val('Sending')
  clearForm:     -> @$('.recipients, .message-textarea').val('')

  showAlert: (type) ->
    @$('.alert').addClass 'hide'
    @$('.alert-type-' + type).removeClass 'hide' if type?
