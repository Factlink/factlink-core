$window = $(window)
$earth = $('.header > .background > .earth')

if $('body').hasClass('controller_home') and $('body').hasClass('action_index')
  scrollHandler = ->
    $earth.css 'top', 190 - Math.max($window.scrollTop(), 0)*0.7
  $window.scroll scrollHandler
  scrollHandler()
else
  $earth.hide()
