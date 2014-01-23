// Adapted from http://stackoverflow.com/a/4758996
FactlinkJailRoot.rangeBox = function(range) {
  var
      boundingRect = range.getBoundingClientRect(),
      body = document.body || document.getElementsByTagName("body")[0],
      clientTop = document.documentElement.clientTop || body.clientTop || 0,
      clientLeft = document.documentElement.clientLeft || body.clientLeft || 0,
      scrollTop = (window.pageYOffset || document.documentElement.scrollTop || body.scrollTop),
      scrollLeft = (window.pageXOffset || document.documentElement.scrollLeft || body.scrollLeft);
  return {
      top: boundingRect.top + scrollTop - clientTop,
      left: boundingRect.left + scrollLeft - clientLeft,
      width: boundingRect.width,
      height: boundingRect.height
  };
};
