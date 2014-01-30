describe '$.distinctDescendants', ->
  it "doesn't filter siblings", ->
    html = """
      <div>
        <div class="element"></div>
        <div class="element"></div>
      </div>
    """
    $elements = $(html).find('.element')

    expect($elements.distinctDescendants().length).to.equal 2

  it "filters parents", ->
    html = """
      <div>
        <div class="element">
          <div class="element"></div>
        </div>
      </div>
    """
    $elements = $(html).find('.element')

    expect($elements.distinctDescendants().length).to.equal 1
