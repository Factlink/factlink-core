(function(Factlink, waitingCount) {
  // Store arguments object so we can use from the setTimeout and loadFactlink
  var arg = arguments;

  // If it takes longer then 5 seconds we just stop
  // TODO maybe some error message here?
  if (waitingCount >= 50) {
    return;
  }

  if ( typeof Factlink === "object" && typeof Factlink.startAnnotating === "function" ) {
    // Start highlighting
    Factlink.startHighlighting();
  } else {
    setTimeout(function() {
      arg.callee(Factlink, ++waitingCount);
    }, 100);
  }
})(window.Factlink, 0);