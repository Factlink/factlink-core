(function () {
  var iframe = document.createElement("iframe");
  var body = document.getElementsByTagName("body")[0];

  iframe.style.display = "none";

  body.insertBefore(iframe, body.firstChild);

  var iDocument = iframe.contentWindow.document;
  var iHead = iDocument.getElementsByTagName("head")[0];

  var script = document.createElement("script");
  script.src = FactlinkConfig.lib + "/dist/factlink.js";

  var configScript = document.createElement("script");
  configScript.type = "text/javascript";
  configScript.innerHTML = "window.FactlinkConfig = " + JSON.stringify(FactlinkConfig) + ";";

  iHead.insertBefore(configScript, iHead.firstChild);
  iHead.insertBefore(script, iHead.firstChild);
}());
