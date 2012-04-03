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
  } else if ( data === "annotate" ) {
    $('#annotate_button>input').prop('checked',true);
  } else if ( typeof data.title !== "undefined" ) {
    if ( data.text.length > 0 ) {
      top.postMessage({message: "changeHeight", height: $(document).height()}, "*");
    }

    $('#title').val(data.title);
    $('#fact').val(data.text);
    $('#url').val(data.url);
  } else if ( data === "blacklist" ) {
    $('#highlight').prop('disabled', true);
    $('#annotate_button>input').prop('disabled', true);
  }
}, false);

passThroughClick( $('#annotate_button>input'), "annotateToggle");
passThroughClick( $('#highlight'), "highlightToggle");

if ( $('.alert').length === 1 ) {
  top.postMessage("showNotification", "*");

  $('.alert').bind('closed', function (e) {
    top.postMessage('hideNotification', "*");
  });
}

})();
