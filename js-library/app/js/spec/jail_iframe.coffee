describe '$.distinctDescendants', ->
  it "doesn't filter siblings", ->
    $div = $ """
      <div>
        <div class="element"></div>
        <div class="element"></div>
      </div>
    """
    expect($div.find('.element').distinctDescendants().length).to.equal 2

  it "filters parents", ->
    $div = $ """
      <div>
        <div class="element">
          <div class="element"></div>
        </div>
        <div class="element">
          <div class="element"></div>
        </div>
      </div>
    """
    expect($div.find('.element').distinctDescendants().length).to.equal 2

  it "works when an earlier parent is selected a second time", ->
    $div = $ """
      <div>
        <div class="element2">
          <div class="element1"></div>
        </div>
      </div>
    """
    expect($div.find('.element1').distinctDescendants().length).to.equal 1
    expect($div.find('.element2').distinctDescendants().length).to.equal 1
