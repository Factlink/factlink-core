function getTextRange() {
  var doc = window.document;
  var d;

  if (doc.getSelection) {
    d = doc.getSelection();
  } else if (doc.selection) {
    d = doc.selection.createRange().text;
  } else {
    d = '';
  }
  return d;
}

Factlink.createFactFromSelection = function(errorCallback){
  var selInfo = Factlink.getSelectionInfo();

  var success = function() {
    Factlink.modal.show.method();
    Factlink.trigger('modalOpened');
    Factlink.prepare.stopLoading();
  };

  var error = function(e) {
    console.error("Error openening modal: ", e);
    if ( errorCallback ) { errorCallback(); }
  };

  Factlink.remote.prepareNewFactlink( selInfo.text,
                                  Factlink.siteUrl(),
                                  selInfo.title,
                                  !!FactlinkConfig.guided,
                                  success,
                                  error);
};

// We make this a global function so it can be used for direct adding of facts
// (Right click with chrome-extension)
Factlink.getSelectionInfo = function() {
  var selection = getTextRange();

  return {
    text: selection.toString(),
    title: window.document.title
  };
};
