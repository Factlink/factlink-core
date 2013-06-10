#= require application
#= require frontend

describe "Backbone.Factlink.TextAreaView", ->
  sampleShortText = 'some text.'
  sampleLongText = 'Various\nbits\nof text\non\nseveral\nlines\n\n\n!'
  model = view = null

  textarea = -> view.$el.find('textarea')

  beforeEach ->
    model = new Backbone.Model({text: 'nothing.'})
    view = new Backbone.Factlink.TextAreaView(model: model)
    #since we need to check how layout works, we need to to include
    #the view in the document.
    $(document.body).append view.render().$el

  it "shows the text", ->
    expect(textarea().val()).to.equal sampleShortText

  it "updates the textarea when the model changes", ->
    model.set text: sampleShortText
    expect(textarea().val()).to.equal sampleShortText

  it "updates the model when the textarea changes", ->
    textarea().val('bla - bla!')
    textarea().trigger 'keyup'
    expect(model.get('text')).to.equal 'bla - bla!'

  it "is initially small and scrollbarless", ->
    expect(textarea().height()).to.be.below 32
    expect(textarea()[0].scrollHeight).to.equal textarea()[0].clientHeight

  it "remains small but gains a scrollbar when text doesn't fit", ->
    initialHeight = textarea().height()
    textarea().val(sampleLongText)
    expect(textarea().height()).to.equal initialHeight
    expect(textarea()[0].scrollHeight).not.to.equal textarea()[0].clientHeight
