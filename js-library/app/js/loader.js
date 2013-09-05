(function() {
  if ( window.FACTLINK !== undefined ) {
    return;
  }
  var hashOfFactlinkCoreFile = "&*HASH_PLACE_HOLDER*&"

  var iframe = document.createElement("iframe"),
      div = document.createElement("div"),
      hasReadyState = "readyState" in iframe,
      flScript = document.createElement('script'),
      scriptLoaded = false, iframeLoaded = false,
      iframeDoc;

  iframe.style.display = "block";
  iframe.style.border = "0px solid transparent";
  iframe.id = "factlink-iframe";

  if(FactlinkConfig.srcPath.match(/\.min\.js$/)) {
    if(hashOfFactlinkCoreFile === "&*HASH_PLACE_HOLDER*&") {
      hashOfFactlinkCoreFile = '';
    } else {
      hashOfFactlinkCoreFile = '.' + hashOfFactlinkCoreFile;
    }
    flScript.src = FactlinkConfig.lib + "/factlink.core.min"+hashOfFactlinkCoreFile+".js";
  }
  else
  {
    flScript.src = FactlinkConfig.lib + FactlinkConfig.srcPath;
  }

  flScript.onload = flScript.onreadystatechange = function () {
    if ((flScript.readyState && flScript.readyState !== "complete" && flScript.readyState !== "loaded") || scriptLoaded) {
      return false;
    }
    flScript.onload = flScript.onreadystatechange = null;
    scriptLoaded = true;

    function proxy(func) {
      window.FACTLINK[func] = function () {
        return iframe.contentWindow.Factlink[func].apply(iframe.contentWindow.Factlink, arguments);
      };
    }

    proxy('on');
    proxy('off');
    proxy('hideDimmer');
    proxy('triggerClick');
    proxy('stopAnnotating');
    proxy('getSelectionInfo');

    if ( window.jQuery ) {
      jQuery(window).trigger('factlink.libraryLoaded');
    }
  };

  window.FACTLINK = {};

  window.FACTLINK.iframeLoaded = function () {
    iframe.contentWindow.document.head.appendChild(flScript);
  };

  // Wrappers for increased CSS specificity
  var wrapper1 = document.createElement("div"),
      wrapper2 = document.createElement("div"),
      wrapper3 = document.createElement("div");
  wrapper1.id = "fl-wrapper-1";
  wrapper2.id = "fl-wrapper-2";
  wrapper3.id = "fl-wrapper-3";
  div.id = "fl";

  wrapper1.appendChild(wrapper2);
  wrapper2.appendChild(wrapper3);
  wrapper3.appendChild(div);
  document.body.appendChild(wrapper1);

  div.insertBefore(iframe, div.firstChild);

  iframeDoc = iframe.contentWindow.document;

  iframeDoc.open();
  iframeDoc.write("<!DOCTYPE html><html><head><script>" +
                    "window.FactlinkConfig = " + JSON.stringify(FactlinkConfig) + ";" +
                  " window.parent.FACTLINK.iframeLoaded();</script></head><body></body></html>");
  iframeDoc.close();
}());
