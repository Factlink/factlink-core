//= require jquery

var // The iFrame
    showFrame = document.getElementById("frame"),
    // The global remote object
    remote = new easyXDM.Rpc({}, {
      remote: {
        hide: {},
        show: {},
        highlightNewFactlink: {},
        stopHighlightingFactlink: {}
      },
      local: {
        showFactlink: function(id, successFn) {
          showFrame.onload = function() {
            showFrame.onload = undefined;
            successFn();
          };

          // Set the source of the iframe
          showFrame.src = "/facts/" + id;
          // Show the overlay
          showFrame.className = "overlay";
        },
        position: function(top, left) {
          try {
            showFrame.contentWindow.position(top, left);
          } catch (e) { // Window not yet loaded
            showFrame.onload = function() {
              showFrame.contentWindow.position(top, left);
            };
          }
        },
        //easyXDM does not support passing functions wrapped in objects (such as options in this case)
        // so therefore we need this workaround
        ajax: function(path, options, successFn, errorFn) {
          ajax(path, $.extend({
            success: successFn,
            error: errorFn
          },options));
        }
      }
    });

function ajax(path, options) {
  $.ajax(path, $.extend({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  }, options));
}