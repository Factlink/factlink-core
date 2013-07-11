$window = $(window)
$earth_background = $('.header > .background > .earth_background ')

if $('body').hasClass('controller_home') and $('body').hasClass('action_index')
  scrollHandler = ->
    $earth_background.css 'top', 190 - Math.max($window.scrollTop(), 0)*0.7
  $window.scroll scrollHandler
  scrollHandler()
else
  $earth_background.hide()
