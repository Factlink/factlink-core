(function(waitingCount) {
  // Store arguments object so we can use from the setTimeout and loadFactlink
  var arg = arguments;
  var Factlink = document.getElementById("factlink-iframe").contentWindow.Factlink;

  // If it takes longer then 5 seconds we just stop
  // TODO maybe some error message here?
  if (waitingCount >= 50) {
    return;
  }

  if ( typeof Factlink === "object" && typeof Factlink.startAnnotating === "function" ) {
    // Start annotating
    Factlink.startAnnotating();
  } else {
    setTimeout(function() {
      arg.callee(Factlink, ++waitingCount);
    }, 100);
  }
})(0);
