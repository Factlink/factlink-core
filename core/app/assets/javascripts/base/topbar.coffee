$top_bar = $('.navbar > .navbar-inner')
$dimmed_top_bar = $top_bar.clone().addClass('dimmed').insertAfter($top_bar)
$earth = $('.header > .background > .earth')

$top_bar.on 'click', 'a.sign_in', ->
  $('.sign_in_bar').animate marginTop: 0, 'slow', -> resetPlaceholders()
  $top_bar.fadeOut "slow"
  $earth.animate marginTop: 104, 'slow'


$dimmed_top_bar.on 'click', 'a.sign_in', ->
  $('.sign_in_bar').animate marginTop: -160, 'slow', -> resetPlaceholders()
  $top_bar.fadeIn "slow"
  $earth.animate marginTop: 0, 'slow'
