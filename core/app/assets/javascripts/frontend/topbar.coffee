$('.bookmarklet').tooltip { placement: "left", offset: 5 }

$('#factlink_search').bind 'focus', ->
  mp_track "Search: Top bar search clicked"
