(function(Factlink) {
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
  
  var highlight_factlink = function( e ) { 
    var fctID = $( this ).attr( 'data-factid' ); 
    // Make sure the hover on an element works on all the paired span elements 
    $( '[data-factid=' + fctID + ']' ).addClass('fl-active');
    Factlink.Indicator.setOpinions( 
    		        { 
    		            percentage: $( this ).attr('data-fact-believe-percentage'), 
    		            authority: $( this ).attr('data-fact-believe-authority') 
    		        },  
    		        { 
    		            percentage: $( this ).attr('data-fact-doubt-percentage'), 
    		            authority: $( this ).attr('data-fact-doubt-authority') 
    		        }, 
    		        { 
    		            percentage: $( this ).attr('data-fact-disbelieve-percentage'), 
    		            authority: $( this ).attr('data-fact-disbelieve-authority') 
    		        });
  }
  var stop_highlighting_factlink = function(e) { 
      var fctID = $( this ).attr( 'data-factid' ); 
    $( '[data-factid=' + $( this ).attr( 'data-factid' ) + ']' ).removeClass('fl-active'); 
     Factlink.Indicator.showFor(fctID, e.pageX - 10, $(e.target).offset().top + 10 ); 
  }
  
  $( 'span.factlink' ).live( 'mouseenter', highlight_factlink)
                      .live('mouseleave', stop_highlighting_factlink );
                      
  var bindClick = function() {
        $(document).bind('click', clickHandler);
      },
      unbindClick = function() {
        $(document).unbind('click', clickHandler);
      },
      clickHandler = function() {
        Factlink.modal.hide.method();
      };
})(window.Factlink);
