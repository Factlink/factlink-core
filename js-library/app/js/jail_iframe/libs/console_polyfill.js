// inspired by https://github.com/paulmillr/console-polyfill
// IE9 (and potentially others) don't support console.log, this avoids crash.
(function(con) {
  'use strict';
  var method, dummy = function() {};
  var methods = ('assert,clear,count,debug,dir,dirxml,error,exception,group,' +
    'groupCollapsed,groupEnd,info,log,markTimeline,profile,profileEnd,' +
    'table,time,timeEnd,timeStamp,trace,warn').split(',');
  if(con.memory !== undefined) con.memory = {};
  while (method = methods.pop()) if(!con[method]) con[method] = dummy;
})(window.console = window.console || window.parent.console || {});
