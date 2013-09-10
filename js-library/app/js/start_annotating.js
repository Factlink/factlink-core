(function(waitingCount) {
  // Store arguments object so we can use from the setTimeout and loadFactlink
  var arg = arguments;

  // If it takes longer then 5 seconds we just stop
  // TODO maybe some error message here?
  if (waitingCount >= 50) {
    return;
  }

  if ( typeof FACTLINK === "object" && typeof FACTLINK.startAnnotating === "function" ) {
    // Start annotating
    FACTLINK.startAnnotating();
  } else {
    setTimeout(function() {
      arg.callee(this, ++waitingCount);
    }, 100);
  }
})(0);
