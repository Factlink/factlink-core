(function() {
var top = window.top;

function passThroughClick(elem, messageKey) {
  elem.bind('click', function() {
    top.postMessage(messageKey, "*");
  });
}

window.addEventListener("message", function(messageObject) {
  if ( messageObject.data === "highlight" ) {
    $('#highlight').prop('checked', true );
  } else if ( messageObject.data === "annotate" ) {
    // Here you can set the initial annotate button status
  } else if ( typeof messageObject.data.title !== "undefined" ) {
    $('#title').val(messageObject.data.title);
    $('#fact').val(messageObject.data.text);
    $('#url').val(messageObject.data.url);
  }
}, false);

passThroughClick( $('#slideUp, #slideDown'), "slideToggle");
passThroughClick( $('#annotate_button'), "annotateToggle");
passThroughClick( $('#highlight'), "highlightToggle");

$('#slideUp, #slideDown').bind('click', function() {
  if ( $( '#slideDown' ).val() === "+ Add new" ) {
    $( this ).val("+ Add new");
  } else {
    $( this ).val("+ Add new");
  }
});

})();