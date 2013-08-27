window.simpleModalWindow = (baseClass, content) ->
  $("#{baseClass}-link").on 'click', ->
    $("#{baseClass}-body").html content
    $(baseClass).fadeIn 'fast'

  $("#{baseClass}-layer").on 'click', ->
    $(baseClass).fadeOut 'fast', ->
      $("#{baseClass}-body").html ''
