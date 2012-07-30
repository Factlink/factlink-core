(function(){
  var iframe = document.createElement("iframe"),
      div = document.createElement("div"),
      hasReadyState = "readyState" in iframe,
      flScript = document.createElement('script'),
      scriptLoaded = false, iframeLoaded = false,
      iframeDoc;

  iframe.style.display = "block";
  iframe.id = "factlink-iframe";

  flScript.src = FactlinkConfig.lib + (FactlinkConfig.srcPath || "/dist/factlink.core.min.js");
  flScript.onload = flScript.onreadystatechange = function () {
    if ((flScript.readyState && flScript.readyState !== "complete" && flScript.readyState !== "loaded") || scriptLoaded) {
      return false;
    }
    flScript.onload = flScript.onreadystatechange = null;
    scriptLoaded = true;

    window.FACTLINK.on = function() {
      iframe.contentWindow.Factlink.on.apply(iframe.contentWindow.Factlink, arguments);
    };

    window.FACTLINK.off = function() {
      iframe.contentWindow.Factlink.off.apply(iframe.contentWindow.Factlink, arguments);
    };

    if ( window.jQuery ) {
      jQuery(window).trigger('factlink.libraryLoaded');
    }
  };

  if ( window.FACTLINK === undefined ) { window.FACTLINK = {}; }

  window.FACTLINK.iframeLoaded = function () {
    iframe.contentWindow.document.head.appendChild(flScript);
  };

  div.id = "fl";

  document.body.appendChild(div);
  div.insertBefore(iframe, div.firstChild);

  iframeDoc = iframe.contentWindow.document;

  iframeDoc.open();
  iframeDoc.write("<!DOCTYPE html><html><head><script>" +
                    "window.FactlinkConfig = " + JSON.stringify(FactlinkConfig) + ";" +
                  " window.parent.FACTLINK.iframeLoaded();</script></head><body></body></html>");
  iframeDoc.close();
}());
