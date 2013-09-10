#= require sinon-chai
#= require sinon
#= require jquery
#= require application
#= require frontend

describe "SubCommentsAddView", ->
  collection = view = null

  beforeEach ->
    window.currentUser = new User

    collection = new Backbone.Collection

    view = new SubCommentsAddView
      addToCollection: collection
    view.render()

  it "adds a SubComment with a trimmed string", ->
    Backbone.sync = ->
    sinon.spy Backbone, "sync"

    view.$('textarea').val('\n\nsome content').trigger('input')
    view.$('.js-submit').click()

    model = Backbone.sync.getCall(0).args[1]
    expect(model.get('content')).to.equal 'some content'
