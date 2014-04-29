// Console-polyfill. MIT license.
// https://github.com/paulmillr/console-polyfill
// Make it safe to do console.log() always.
(function (con) {
  'use strict';
  var method;
  var methods = 'assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,markTimeline,profile,profileEnd,time,timeEnd,trace,warn'.split(',');
  con.memory = con.memory || {};
  while (method = methods.pop())
    con[method] = con[method] || (function() {});
})(window.console = window.console || {});
