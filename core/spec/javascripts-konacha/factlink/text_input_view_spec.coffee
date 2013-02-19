#= require application
#= require frontend

describe "Backbone.Factlink.TextInputView", ->
  model = view = null

  beforeEach ->
    model = new Backbone.Model({text: 'hi'})
    view = new Backbone.Factlink.TextInputView(model: model)
    view.render()

  it "should show the text", ->
    view.$el.find('.typeahead').val().should.equal 'hi'

  it "should update the input field", ->
    model.set text: 'bla'
    view.$el.find('.typeahead').val().should.equal 'bla'

  it "should update the model", ->
    view.$el.find('.typeahead').attr('value', 'bla')
    view.$el.find('.typeahead').trigger 'keyup'
    model.get('text').should.equal 'bla'
