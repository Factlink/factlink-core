// The iFrame which holds the intermediate
var iFrame = $("<div />").attr({
  "id": "factlink-modal-frame"
});
iFrame.hide();
iFrame.appendTo(Factlink.el);

Factlink.hideDimmer = function () {
  iFrame.css('background', 'none');
};

Factlink.showInfo = function(factId, successCallback) {
  Factlink.remote.showFactlink(factId, function successFn() {
    Factlink.modal.show.method();
    Factlink.trigger('modalOpened');

    if ($.isFunction(successCallback)) {
      successCallback();
    }
  });
};

var clickHandler = function() {
  Factlink.modal.hide.method();
};

var bindClick = function() {
  $(document).bind('click', clickHandler);
};

var unbindClick = function() {
  $(document).unbind('click', clickHandler);
};

// Object which holds the methods that can be called from the intermediate iframe
// These methods are also used by the internal scripts and can be called through
// Factlink.modal.FUNCTION.method() because easyXDM changes the object structure
Factlink.modal = {
  hide: function() {
    unbindClick();
    iFrame.fadeOut('fast');

    Factlink.trigger('modalClosed');
  },
  show: function() {
    bindClick();
    iFrame.fadeIn('fast');
  },
  highlightNewFactlink: function(fact, id, opinions) {
    var fct = Factlink.selectRanges(Factlink.search(fact), id, opinions);

    $.merge(Factlink.Facts, fct);
    //@TODO: Authority & opinions need to be added back in

    Factlink.trigger("factlinkAdded");

    Factlink.modal.hide.method();

    $('#fl').append("<div class='fl-message' style='display:none'>Factlink is created!</div>");
    $('#fl .fl-message').fadeIn('slow');
    setTimeout(function() {
      $('#fl .fl-message').fadeOut('slow');
    }, 2545);
    return fct;
  },
  stopHighlightingFactlink: function(id) {
    $('span.factlink[data-factid=' + id + ']').each(function(i, val) {
      $(val).contents().unwrap();
    });
  },
  trigger: function (e) {
    Factlink.trigger(e);
  }
};
