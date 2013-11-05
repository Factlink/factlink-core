#= require jquery
#= require application
#= require frontend

describe 'StartConversationView', ->
  describe 'initial state', ->
    it 'contains the defaultMessage in the textarea', ->
      view = new StartConversationView defaultMessage: 'henk'
      view.render()
      content = view.$('.js-message-textarea').val()
      expect(content).to.equal "henk"

    it 'contains the text "Check out this Factlink!"" in the textarea when no default message is given', ->
      view = new StartConversationView
      view.render()
      content = view.$('.js-message-textarea').val()
      expect(content).to.equal "Check out this Factlink!"


  describe "clicking on the textarea", ->
    it 'should select the text when unchanged', ->
      view = new StartConversationView defaultMessage: 'henk'
      view.render()
      $('body').html(view.el)

      $textarea = view.$('.js-message-textarea')

      $textarea.trigger('focus')

      selection = $textarea.val().substring(
        $textarea[0].selectionStart, $textarea[0].selectionEnd)

      expect(selection).to.equal "henk"

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

      expect(selection).to.equal ""
