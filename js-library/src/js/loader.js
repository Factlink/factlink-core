(function () {
  function createIframe() {
    var body = document.getElementsByTagName("body")[0];
    var iframe = document.createElement("iframe");
    var div = document.createElement("div");

    iframe.style.display = "none";
    iframe.id = "factlink-iframe";
    div.id = "fl";
    div.style.display = "none";

    body.appendChild(div);
    div.insertBefore(iframe, div.firstChild);

    return iframe;
  }

  var iframe = createIframe();

  var iDocument = iframe.contentWindow.document;
  var iHead = iDocument.getElementsByTagName("head")[0];
  var head = document.getElementsByTagName("head")[0];

  var flScript = document.createElement("script");
  flScript.src = FactlinkConfig.lib + (FactlinkConfig.srcPath || "/dist/factlink.core.min.js");

  var configScript = document.createElement("script");
  configScript.type = "text/javascript";
  configScript.innerHTML = "window.FactlinkConfig = " + JSON.stringify(FactlinkConfig) + ";";

  iHead.insertBefore(configScript, iHead.firstChild);
  iHead.insertBefore(flScript, iHead.firstChild);
}());
