if not $('#watch_factlink_video').length
  return

iframe = $('<iframe src="https://player.vimeo.com/video/39821677?autoplay=1" style="width:740px; height:416px; border: 0px;"></iframe>')

$('#watch_factlink_video').on 'click', ->
  iframe.clone().appendTo( $('#factlink_video > .modal-body') );

$('#factlink_video').on 'hidden', ->
  $('#factlink_video > .modal-body').empty();
