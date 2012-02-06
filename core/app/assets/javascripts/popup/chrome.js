(function() {
var top = window.top;

function passThroughClick(elem, messageKey) {
  elem.bind('click', function() {
    top.postMessage(messageKey, "*");
  });
}

window.addEventListener("message", function(messageObject) {
  var data = messageObject.data;
  if ( data === "highlight" ) {
    $('#highlight').prop('checked', true );
  } else if ( data === "auto_annotate" ) {
    $('#annotate_button').hide();
  } else if ( data === "annotate" ) {
    $('#annotate_button').addClass('active');
  } else if ( typeof data.title !== "undefined" ) {
    $('#title').val(data.title);
    $('#fact').val(data.text);
    $('#url').val(data.url);
  } else if ( data === "blacklist" ) {
    $('#highlight').prop('disabled', true);
    $('#annotate_button').prop('disabled', true);
  }
}, false);

passThroughClick( $('#slideUp, #slideDown'), "slideToggle");
passThroughClick( $('#annotate_button'), "annotateToggle");
passThroughClick( $('#highlight'), "highlightToggle");

$('#annotate_button').bind('click', function() {
  if ($(this).hasClass("active")) {
    $(this).removeClass("active");
  } else {
    $(this).addClass("active");
  }
});

})();
