class window.SendMessageView extends Backbone.Marionette.ItemView
  events:
    "click .submit": 'submit'

  template:
    text: """
      hoi<br>
      <input type="text" class='recipient'><br>
      <textarea class='content'></textarea><br>
      <input type="submit" class='submit'>
    """
  initialize: ->
    @model = new Conversation

  submit: ->
    @model.set 'recipients', [@$('.recipient').val(), currentUser.get('username')]
    @model.set 'sender', currentUser.get('username')
    @model.set 'content', @$('.content').val()
    console.info "MESSAGE", @model.toJSON()
    @model.save()
