(function() {


/*!
  * $script.js v1.3
  * https://github.com/ded/script.js
  * Copyright: @ded & @fat - Dustin Diaz, Jacob Thornton 2011
  * Follow our software http://twitter.com/dedfat
  * License: MIT
  */
!function(a,b,c){function t(a,c){var e=b.createElement("script"),f=j;e.onload=e.onerror=e[o]=function(){e[m]&&!/^c|loade/.test(e[m])||f||(e.onload=e[o]=null,f=1,c())},e.async=1,e.src=a,d.insertBefore(e,d.firstChild)}function q(a,b){p(a,function(a){return!b(a)})}var d=b.getElementsByTagName("head")[0],e={},f={},g={},h={},i="string",j=!1,k="push",l="DOMContentLoaded",m="readyState",n="addEventListener",o="onreadystatechange",p=function(a,b){for(var c=0,d=a.length;c<d;++c)if(!b(a[c]))return j;return 1};!b[m]&&b[n]&&(b[n](l,function r(){b.removeEventListener(l,r,j),b[m]="complete"},j),b[m]="loading");var s=function(a,b,d){function o(){if(!--m){e[l]=1,j&&j();for(var a in g)p(a.split("|"),n)&&!q(g[a],n)&&(g[a]=[])}}function n(a){return a.call?a():e[a]}a=a[k]?a:[a];var i=b&&b.call,j=i?b:d,l=i?a.join(""):b,m=a.length;c(function(){q(a,function(a){h[a]?(l&&(f[l]=1),o()):(h[a]=1,l&&(f[l]=1),t(s.path?s.path+a+".js":a,o))})},0);return s};s.get=t,s.ready=function(a,b,c){a=a[k]?a:[a];var d=[];!q(a,function(a){e[a]||d[k](a)})&&p(a,function(a){return e[a]})?b():!function(a){g[a]=g[a]||[],g[a][k](b),c&&c(d)}(a.join("|"));return s};var u=a.$script;s.noConflict=function(){a.$script=u;return this},typeof module!="undefined"&&module.exports?module.exports=s:a.$script=s}(this,document,setTimeout);



function loadScripts(base_url){
  var timestamp = '?' + (new Date()).getTime(),
      toLoad = [
          [
              base_url + '/build/jquery-1.6.1.js',
              base_url + '/build/easyXDM/easyXDM.js',
              base_url + '/build/underscore.js'
          ],
          [
              base_url + '/src/js/core.js' + timestamp
          ],
          [
              base_url + '/build/jquery.scrollTo-1.4.2.js',
              base_url + '/build/jquery.hoverintent.js',
              base_url + '/src/js/models/fact.js' + timestamp,
              base_url + '/src/js/views/ballooney_thingy.js' + timestamp,
              base_url + '/src/js/views/balloon.js' + timestamp,
              base_url + '/src/js/views/prepare.js' + timestamp,
              base_url + '/src/js/annotate.js' + timestamp
          ],
          [
              base_url + '/src/js/replace.js' + timestamp,
              base_url + '/src/js/scrollto.js' + timestamp,
              base_url + '/src/js/search.js' + timestamp,
              base_url + '/src/js/create.js' + timestamp,
              base_url + '/src/js/modal.js' + timestamp,
              base_url + '/src/js/lib/indicator.js' + timestamp
          ],
          [
              base_url + '/src/js/xdm.js' + timestamp
          ],
          [
              base_url + '/src/js/last.js' + timestamp
          ]
      ];

  // We use a self invoking anonymous function to load all the scripts
  // needed.
  (function(i){
      // Load the script
      $script(toLoad[i], i);

      // If there is more to load
      if ( toLoad[i+1] !== undefined ) {
          // Store the current function object (so we can call it from the
          // ready method of $script)
          var toCall = arguments.callee;

          // When $script is done loading the first batch, start loading
          // the next one
          $script.ready( i, function() {
              // Make a recursive call to make sure all scripts get loaded
              toCall(i+1);
          });
      } else {
          // Nothing to load anymore, call the ready method.
          $script.ready( i, function() {
            console.info( "Factlink library loaded" );
          });
      }
  })(0);
}

loadScripts(window.FactlinkConfig.lib)

})();