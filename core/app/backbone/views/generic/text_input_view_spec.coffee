#= require jasmine-jquery

describe "window.TextInputView", ->
  model = view = null

  beforeEach ->
    model = new Backbone.Model({text: 'hi'})
    view = new TextInputView(model: model)
    view.render()

  it "should show the text", ->
    expect(view.$el.find('.typeahead')).toHaveValue('hi')

  it "should update the input field", ->
    model.set text: 'bla'
    expect(view.$el.find('.typeahead')).toHaveValue('bla')

  it "should update the model", ->
    view.$el.find('.typeahead').attr('value', 'bla')
    view.$el.find('.typeahead').trigger 'keyup'
    expect(model.get('text')).toEqual('bla')
