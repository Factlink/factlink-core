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
    if ( data.text.length <= 0 ) {
      $('#new_fact_form').hide(0, updateHeight);
    }

    $('#title').val(data.title);
    $('#fact').val(data.text);
    $('#url').val(data.url);
  } else if ( data === "blacklist" ) {
    $('#highlight').prop('disabled', true);
    $('#blacklisted').show(0, updateHeight);
    $('#annotate_button').hide();
  } else if ( data === "error") {
    $('#highlight').prop('disabled', true);
    $('#error_loading_factlink').show(0, updateHeight);
    $('#annotate_button>input').prop('disabled', true);
  }
  
  
}, false);

function updateHeight(){
  top.postMessage({message: "changeHeight", height: $(document).height()}, "*");
}

passThroughClick( $('#annotate_button>input'), "annotateToggle");
passThroughClick( $('#highlight'), "highlightToggle");

if ( $('.alert').length === 1 ) {
  top.postMessage("showNotification", "*");

  $('.alert').bind('closed', function (e) {
    top.postMessage('hideNotification', "*");
  });
}

$('#cancel').on('click', function (e) {
  e.preventDefault();

  addToChannelView.resetClickedState();

  top.window.close();
});


})();
