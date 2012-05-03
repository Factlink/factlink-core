(function() {
var top = window.top;

var listenFor = (function() {
  var boundEvents = {};

  window.addEventListener("message", function(messageObject) {
    var messageKey = messageObject.data.message;

    if ( typeof boundEvents[messageKey] === "function" ) {
      boundEvents[messageKey].apply(this, arguments);
    }
  }, false);

  return function(message, handler) {
    boundEvents[message] = handler;
  };
})();

function passThroughClick(elem, messageKey) {
  elem.bind('click', function() {
    top.postMessage({message: messageKey}, "*");
  });
}

function updateHeight(){
  var height = document.body.scrollHeight;

  top.postMessage({message: "changeHeight", height: height}, "*");
}

listenFor("annotate", function(messageObject) {
  $('#annotate_button>input').prop('checked',true);
});

listenFor("setFormData", function(messageObject) {
  if ( messageObject.data.text.length > 0 ) {
    $('#new_fact_form').show();
    $('#createFactlinkHelp').hide();
  }

  $('#title').val(messageObject.data.title);
  $('.fact>textarea').val(messageObject.data.text);
  $('.fact>p').html(messageObject.data.text);
  $('#url').val(messageObject.data.url);

  updateHeight();
});

listenFor("blacklist", function(messageObject) {
  $('#highlight').prop('disabled', true);
  $('#blacklisted').show();
  $('#annotate_button').hide();

  console.info( "Blacklisting" );
  updateHeight();
});

listenFor("hideError", function(messageObject) {
  $('#highlight').prop('disabled', false);
  $('#error_loading_factlink').hide();
  $('#annotate_button>input').prop('disabled', false);

  updateHeight();
});

listenFor("error", function(messageObject) {
  $('#highlight').prop('disabled', true);
  $('#error_loading_factlink').show();
  $('#annotate_button>input').prop('disabled', true);

  updateHeight();
});

passThroughClick( $('#annotate_button>input'), "annotateToggle");

// When the cancel button is clicked, close the popup
$('#cancel').on('click', function (e) {
  e.preventDefault();

  addToChannelView.resetClickedState();

  top.window.close();
});

$(window).on('resize', function(e) {
  console.info( "Resize" );
  updateHeight();
});
})();
