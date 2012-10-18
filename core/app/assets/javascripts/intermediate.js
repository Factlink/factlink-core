//= require jquery
//= require jquery.prevent_scroll_propagation

var // The iFrame
    showFrame = document.getElementById("frame"),
    xdm = window.easyXDM.noConflict("FACTLINK"),
    // The global remote object
    remote = new xdm.Rpc({}, {
      remote: {
        hide: {},
        show: {},
        highlightNewFactlink: {},
        stopHighlightingFactlink: {},
        createdNewFactlink: {},
        trigger: {}
      },
      local: {
        showFactlink: function(id, successFn) {
          var successCalled  = 0;
          var onLoadSuccess = function(){
            if (! successCalled ){
              successCalled++;
              successFn();
            }

          };
          showFrame.onload = onLoadSuccess;

          // Somehow only lower case letters seem to work for those events --mark
          $(document).bind("modalready", onLoadSuccess);

          showFrame.src = "/facts/" + id + "?layout=client";

          // Show the overlay
          showFrame.className = "overlay";
        },

        prepareNewFactlink: function(text, siteUrl, siteTitle, successFn, errorFn) {

          var successCalled = 0;
          var onLoadSuccess = function() {
            if (! successCalled ){
              successCalled++;

              if ( $.isFunction( successFn ) ) {
                successFn();
              }
            }
          };

          showFrame.onload = onLoadSuccess;

          // Somehow only lower case letters seem to work for those events --mark
          $(document).bind("modalready", onLoadSuccess);

          showFrame.src = "/facts/new" +
                                      "?fact="  + encodeURIComponent(text) +
                                      "&url="   + encodeURIComponent(siteUrl) +
                                      "&title=" + encodeURIComponent(siteTitle) +
                                      "&layout=client";
          // Show the overlay
          showFrame.className = "overlay";


          var onFactlinkCreated = function(e, id) {
            remote.highlightNewFactlink(text, id);
          };
          $(document).bind("factlinkCreated", onFactlinkCreated);

        },

        position: function(top, left) {
          try {
            showFrame.contentWindow.position(top, left);
          } catch (e) { // Window not yet loaded
            showFrame.onload = function() {
              showFrame.contentWindow.position(top, left);
            };
          }
        }
      }
    });

$('iframe').preventScrollPropagation();
