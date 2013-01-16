isScrolledIntoView = ($elem)->
  [docViewTop, docViewBottom] = windowTopBottom()
  [elemTop, elemBottom] = elemTopBottom($elem)
  return ((elemBottom <= docViewBottom) && (elemTop >= docViewTop));

isInsideContainerBoundaries = ($elem, $container) ->
  [containerViewTop, containerViewBottom] = elemTopBottom($container)
  [elemTop, elemBottom] = elemTopBottom($elem)
  return ((elemBottom <= containerViewBottom) && (elemTop >= containerViewTop));

windowTopBottom = ->
  docViewTop = $(window).scrollTop();
  docViewBottom = docViewTop + $(window).height();
  [docViewTop, docViewBottom]

elemTopBottom = ($el)->
  elemTop = $el.offset().top;
  elemBottom = elemTop + $el.height();
  [elemTop, elemBottom]



# situation: we have a block within a container block
# we want to see the block, so we might need to scroll the containerblock
# and we might need to scroll the window
window.scrollIntoViewWithinContainer = ($el, $container)->
  $container ?= $el.parent()

  unless isScrolledIntoView($el) and isInsideContainerBoundaries($el, $container)
    container = $container[0]
    
    if (container.scrollHeight > container.clientHeight)
      $el[0].scrollIntoView(true)
      container.scrollIntoView(false)

# Situation: same as above, but we do NOT want to scroll the page
# Also, we scroll the element to the center of the parent container
window.scrollToCenterWithinContainer = ($el)->
  $container = $el.parent()

  y = $el.position().top + $el.outerHeight()/2
  y -= $container.height()/2
  
  $container.scrollTop Math.max(0, y)
