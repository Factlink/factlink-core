window.disableInputWithDisableWith = ($el)->
  disable_with_text = $el.attr("data-disable-with")
  return unless disable_with_text

  if $el.is("input")
    $el.val(disable_with_text)
       .addClass("disabled")
       .prop('disabled', true)
  else
    $el.html(disable_with_text)
       .addClass("disabled")

setLoadingText = ->
  disableInputWithDisableWith $(this)

$("a[data-disable-with]:not([data-remote])")
  .on("click", setLoadingText)
