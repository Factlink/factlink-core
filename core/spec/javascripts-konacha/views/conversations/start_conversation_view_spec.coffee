#= require application
#= require frontend

describe 'StartConversationView', ->
  it 'initial state', ->
    view = new window.StartConversationView
    view.render()
    content = view.$('.js-message-textarea').val()
    content.should.equal "Check out this Henk!"
