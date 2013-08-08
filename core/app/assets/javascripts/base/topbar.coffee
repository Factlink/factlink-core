$top_bar = $('.navbar > .navbar-inner')
if $top_bar.find('a.sign_in').length
  $dimmed_top_bar = $top_bar.clone().addClass('dimmed').insertAfter($top_bar)
  $earth_background = $('.header > .background > .earth_background')

  $top_bar.on 'click', 'a.sign_in', ->
    $('.sign_in_bar').animate marginTop: 0, 'slow', -> resetPlaceholders()
    $top_bar.fadeOut "slow"
    $earth_background.animate marginTop: 104, 'slow'


  $dimmed_top_bar.on 'click', 'a.sign_in', ->
    $('.sign_in_bar').animate marginTop: -160, 'slow', -> resetPlaceholders()
    $top_bar.fadeIn "slow"
    $earth_background.animate marginTop: 0, 'slow'
