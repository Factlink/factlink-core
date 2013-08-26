#= require jquery
#= require application
#= require frontend

describe "Backbone.Factlink.TextInputView", ->
  model = view = null

  beforeEach ->
    model = new Backbone.Model({text: 'hi'})
    view = new Backbone.Factlink.TextInputView(model: model)
    view.render()

  it "should show the text", ->
    expect(view.$el.find('.typeahead').val()).to.equal 'hi'

  it "should update the input field", ->
    model.set text: 'bla'
    expect(view.$el.find('.typeahead').val()).to.equal 'bla'

  it "should update the model", ->
    view.$el.find('.typeahead').attr('value', 'bla')
    view.$el.find('.typeahead').trigger 'keyup'
    expect(model.get('text')).to.equal 'bla'
