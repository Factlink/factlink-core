$window = $(window)
$earth = $('.header > .background > .earth')

if $('body').hasClass('controller_home') and $('body').hasClass('action_index')
	$window.scroll ->
	  $earth.css 'top', 190-$window.scrollTop()*0.8
else
	$earth.hide()