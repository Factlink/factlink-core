class window.SendMessageView extends Backbone.Marionette.ItemView
  events:
    "click .submit": 'submit'

  template: 'messages/send'

  initialize: ->
    @model = new Conversation

  submit: ->
    @model.set 'recipients', [@$('.recipient').val(), currentUser.get('username')]
    @model.set 'sender', currentUser.get('username')
    @model.set 'content', @$('.content').val()


    @model.save [],
      success: =>
        @$('.message').html('gelukt :)')
        @model = new Conversation
        enableSubmit()
      error: =>
        @$('.message').html('mislukt :(')
        enableSubmit()

  enableSubmit:  -> @$('.submit').prop('disabled',false).val('Submit')
  disableSumbit: -> @$('.submit').prop('disabled',true ).val('Submitting')
