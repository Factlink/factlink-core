# easy event handler which just toggles a class on the element of the view


window.ToggleMixin =
  addShowHideToggle: (togglename, selector) ->
    this[togglename+'On'] = -> @$(selector).show()
    this[togglename+'Off'] = -> @$(selector).hide()

window.ClassToggleMixin =  (togglename) ->
  extra_methods = {}
  extra_methods[togglename+'On'] = -> @$el.addClass(togglename)
  extra_methods[togglename+'Off'] = -> @$el.removeClass(togglename)
  extra_methods
