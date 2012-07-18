(function () {
  function createIframe() {
    var body = document.getElementsByTagName("body")[0];
    var iframe = document.createElement("iframe");
    var div = document.createElement("div");

    iframe.style.display = "none";
    iframe.id = "factlink-iframe";
    div.id = "fl";

    body.appendChild(div);
    div.insertBefore(iframe, div.firstChild);

    return iframe;
  }

  var iframe = createIframe();
  var iDocument = iframe.contentWindow.document;
  var iHead = iDocument.getElementsByTagName("head")[0];
  var head = document.getElementsByTagName("head")[0];
  var flScript = document.createElement("script");
  var loaded = false;
  var configScript = document.createElement("script");

  flScript.src = FactlinkConfig.lib + (FactlinkConfig.srcPath || "/dist/factlink.core.min.js");
  flScript.onload = flScript.onreadystatechange = function () {
    if ((flScript.readyState && flScript.readyState !== "complete" && flScript.readyState !== "loaded") || loaded) {
      return false;
    }
    flScript.onload = flScript.onreadystatechange = null;
    loaded = true;

    if ( window.jQuery ) {
      window.FACTLINK.on = function() {
        iframe.contentWindow.Factlink.on.apply(iframe.contentWindow.Factlink, arguments);
      };

      window.FACTLINK.off = function() {
        iframe.contentWindow.Factlink.off.apply(iframe.contentWindow.Factlink, arguments);
      };

      jQuery(window).trigger('factlink.libraryLoaded');
    }
  };

  configScript.type = "text/javascript";
  configScript.innerHTML = "window.FactlinkConfig = " + JSON.stringify(FactlinkConfig) + ";";

  iHead.insertBefore(configScript, iHead.firstChild);
  iHead.insertBefore(flScript, iHead.firstChild);
}());
