#= require application
#= require frontend

describe 'StartConversationView', ->
  describe 'initial state', ->
    it 'contains the text "Check out this Factlink!"" in the textarea', ->
      view = new StartConversationView
      view.render()
      content = view.$('.js-message-textarea').val()
      content.should.equal "Check out this Factlink!"


  describe "clicking on the textarea", ->
    it 'should select the text when unchanged', ->
      view = new StartConversationView
      view.render()
      $('body').html(view.el)

      $textarea = view.$('.js-message-textarea')

      $textarea.trigger('focus')

      selection = $textarea.val().substring(
        $textarea[0].selectionStart, $textarea[0].selectionEnd)

      selection.should.equal "Check out this Factlink!"

    it 'should not select the text when changed', ->
      view = new StartConversationView
      view.render()
      $('body').html(view.el)

      $textarea = view.$('.js-message-textarea')

      $textarea.
        val('henk').
        trigger('focus')

      selection = $textarea.val().substring(
        $textarea[0].selectionStart, $textarea[0].selectionEnd)

      selection.should.equal ""
