$window = $(window)
$earth = $('.header-earth')

if $earth.is(':visible')
  scrollHandler = ->
    $earth.css 'margin-top', 30-0.3*Math.max($window.scrollTop(), 0)
  $window.scroll scrollHandler
  scrollHandler()
else
  $earth.hide()
