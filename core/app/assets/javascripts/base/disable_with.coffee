window.disableInputWithDisableWith = ($el)->
  if $el.is("input")
    $el.val($el.attr("data-disable-with"))
       .addClass("disabled")
       .prop('disabled', true)
  else
    $el.html($el.attr("data-disable-with"))
       .addClass("disabled")

setLoadingText = ->
  disableInputWithDisableWith $(this)

$("a[data-disable-with]:not([data-remote])")
  .on("click", setLoadingText)
