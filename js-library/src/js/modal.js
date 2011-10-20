(function(Factlink, $, _, easyXDM, undefined) {
  // The iFrame which holds the intermediate
  var iFrame = $("<div />").attr({
    "id": "factlink-modal-frame"
  }).appendTo('body');

  Factlink.showInfo = function(el, showEvidence) {
    Factlink.remote.showFactlink(el.getAttribute("data-factid"), showEvidence, function ready() {
      Factlink.modal.show.method();
    });
  };

  // Handle a user click
  $('span.factlink').live('click', function(e) {
    var self = this;
    // A custom switch-like module
    var modusHandler = (function() {
      return {
        default: function() {
          Factlink.showInfo(el=self, showEvidence=false);
        }, 
        addToFact: function() {
          Factlink.prepare.show(e.pageX, e.pageY);
          Factlink.prepare.setFactId(self.getAttribute("data-factid"));
        }
      };
    })();
    modusHandler[FactlinkConfig.modus]();
  });

  var clickHandler = function() {
        Factlink.modal.hide.method();
      };
  var bindClick = function() {
        $(document).bind('click', clickHandler);
      };
  var  unbindClick = function() {
        $(document).unbind('click', clickHandler);
      };


  // Object which holds the methods that can be called from the intermediate iframe
  // These methods are also used by the internal scripts and can be called through
  // Factlink.modal.FUNCTION.method() because easyXDM changes the object structure
  Factlink.modal = {	
    hide: function() {
      unbindClick();
      iFrame.hide();
    },
    show: function() {
      bindClick();
      iFrame.show();
    },
    highlightNewFactlink: function(fact, id) {
      Factlink.selectRanges(Factlink.search(fact), id, {
        believe: {
          percentage: 0,
          authority: 0
        },
        doubt: {
          percentage: 0,
          authority: 0
        },
        disbelieve: {
          percentage: 0,
          authority: 0
        }
      });
    },
    stopHighlightingFactlink: function(id) {
      $('span.factlink[data-factid=' + id + ']').each(function(i, val) {
        if ($(val).is('.fl-first')) {
          $(val).remove();
        } else {
          $(val).before($(val).text()).remove();
        }
      });
    }
  };
})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);