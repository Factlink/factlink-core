class window.StartConversationView extends Backbone.Marionette.ItemView
  events:
    "click .submit": 'submit'

  template: 'conversations/start_conversation'

  initialize: ->
    @conversation = new Conversation

  submit: ->
    @conversation.set 'recipients', [@$('.recipients').val(), currentUser.get('username')]
    @conversation.set 'sender', currentUser.get('username')
    @conversation.set 'content', @$('.text').val()
    @conversation.set 'fact_id', @model.id

    @showAlert null
    @disableSubmit()
    @conversation.save [],
      success: =>
        @conversation = new Conversation
        @showAlert 'success'
        @enableSubmit()
      error: =>
        @showAlert 'error'
        @enableSubmit()

  enableSubmit:  -> @$('.submit').prop('disabled',false).val('Send')
  disableSubmit: -> @$('.submit').prop('disabled',true ).val('Sending')
  showAlert: (type) ->
    @$('.alert').addClass 'hide'
    @$('.alert-' + type).removeClass 'hide' if type?
