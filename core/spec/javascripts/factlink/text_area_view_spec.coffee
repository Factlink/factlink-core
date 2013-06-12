#= require application
#= require frontend

describe "Backbone.Factlink.TextAreaView", ->
  initialText = 'something.'
  sampleShortText = 'some text.'
  sampleLongText = 'Various\nbits\nof text\non\nseveral\nlines\n\n\n!'
  model = view = null

  console.info '\n\n\n\n'
  console.info Object.getOwnPropertyNames(window.parent).sort().join("\n")

  textarea = -> view.$el.find('textarea')

  beforeEach ->
    model = new Backbone.Model({text: initialText})
    view = new Backbone.Factlink.TextAreaView(model: model)
    #since we need to check how layout works, we need to to include
    #the view in the document.
    $(document.body).append view.render().$el

  it "shows the text", ->
    expect(textarea().val()).to.equal initialText

  it "updates the textarea when the model changes", ->
    model.set text: sampleShortText
    expect(textarea().val()).to.equal sampleShortText

  it "updates the model when the textarea changes", ->
    textarea().val('bla - bla!')
    textarea().trigger 'keyup'
    expect(model.get('text')).to.equal 'bla - bla!'

  it "is initially small and scrollbarless", ->
    expect(textarea().height()).to.be.below 45
    expect(textarea()[0].scrollHeight).to.equal textarea()[0].clientHeight

  it "grows vertically and avoids a scrollbar when text doesn't fit", ->
    initialHeight = textarea().height()
    textarea().val(sampleLongText)
    expect(textarea().height()).not.to.equal initialHeight
    expect(textarea()[0].scrollHeight).to.equal textarea()[0].clientHeight

  #it 'swallows any return-key presses.', ->
    #unfortunately this is untestable due to the JS sandbox.
    #you can simulate keydown/keypress/keyup, but the browser itself
    #ignores those simulated events so the textarea isn't updated.
