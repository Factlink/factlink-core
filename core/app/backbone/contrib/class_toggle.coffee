# easy event handler which just toggles a class on the element of the view


window.ToggleMixin =
  addClassToggle: (togglename) ->
    this[togglename+'On'] = -> @$el.addClass(togglename)
    this[togglename+'Off'] = -> @$el.removeClass(togglename)

  addShowHideToggle: (togglename, selector) ->
    this[togglename+'On'] = -> @$(selector).show()
    this[togglename+'Off'] = -> @$(selector).hide()
  