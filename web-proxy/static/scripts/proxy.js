/*!
  * $script.js v1.3
  * https://github.com/ded/script.js
  * Copyright: @ded & @fat - Dustin Diaz, Jacob Thornton 2011
  * Follow our software http://twitter.com/dedfat
  * License: MIT
  */
!function(a,b,c){function t(a,c){var e=b.createElement("script"),f=j;e.onload=e.onerror=e[o]=function(){e[m]&&!/^c|loade/.test(e[m])||f||(e.onload=e[o]=null,f=1,c())},e.async=1,e.src=a,d.insertBefore(e,d.firstChild)}function q(a,b){p(a,function(a){return!b(a)})}var d=b.getElementsByTagName("head")[0],e={},f={},g={},h={},i="string",j=!1,k="push",l="DOMContentLoaded",m="readyState",n="addEventListener",o="onreadystatechange",p=function(a,b){for(var c=0,d=a.length;c<d;++c)if(!b(a[c]))return j;return 1};!b[m]&&b[n]&&(b[n](l,function r(){b.removeEventListener(l,r,j),b[m]="complete"},j),b[m]="loading");var s=function(a,b,d){function o(){if(!--m){e[l]=1,j&&j();for(var a in g)p(a.split("|"),n)&&!q(g[a],n)&&(g[a]=[])}}function n(a){return a.call?a():e[a]}a=a[k]?a:[a];var i=b&&b.call,j=i?b:d,l=i?a.join(""):b,m=a.length;c(function(){q(a,function(a){h[a]?(l&&(f[l]=1),o()):(h[a]=1,l&&(f[l]=1),t(s.path?s.path+a+".js":a,o))})},0);return s};s.get=t,s.ready=function(a,b,c){a=a[k]?a:[a];var d=[];!q(a,function(a){e[a]||d[k](a)})&&p(a,function(a){return e[a]})?b():!function(a){g[a]=g[a]||[],g[a][k](b),c&&c(d)}(a.join("|"));return s};var u=a.$script;s.noConflict=function(){a.$script=u;return this},typeof module!="undefined"&&module.exports?module.exports=s:a.$script=s}(this,document,setTimeout);

(function(window, document){
// Dustin Diaz - $script.js
var domReady = function(fn) {
  /in/.test( document['readyState'] ) ? setTimeout( function() { domReady(fn); }, 50) : fn();
};

domReady(function(){
  var a = document.getElementsByTagName("a");

  /**
   * Replace all <a> elements with a proxied URL
   */
  for ( var i = 0, j = a.length; i < j; i++ ) {
    var href = a[i].href;

    if ( href.search(/https?:\/\//) === 0 ) {
      a[i].href = window.FactlinkProxyConfig.PROXY_URL + '/?url=' + escape(href);
      a[i].target = "_top";

      //prevent quietly changing the url afterwards
      //at least needed for the google search results
      a[i].onmousedown="";
      a[i].onclick="";
      a[i].onmouseup="";

    } else if ( href.search(/mailto:/) !== 0 && href.search(/javascript:/) !== 0 ) {
        console.info( "No matching for href: " + href );
    }
  }

  /**
   * Replace all <form> actions with a proxied URL
   * Send the action URL in a hidden field.
   */
  var forms = document.getElementsByTagName("form");

  for ( var i = 0, j = forms.length; i < j; i++ ) {
    // Store the current a-tag
    var form = forms[i];
    var action = form.action;
    var valid = false;

    if ( action.length > 0 ) {
      if ( action.search(/http(s|):\/\//) !== 0 ) {
         console.info( "No matching for href: " + href );
      } else {
        valid = true;
      }

    }

    if (form.method !== undefined && form.method.match(/post/i)){
      valid = false;
    }

    if ( valid ) {
        // Add the action url to form
      var input = document.createElement('input');
      input.setAttribute('type', 'hidden');
      input.setAttribute('name', 'factlinkFormUrl');
      input.setAttribute('value', action);
      form.appendChild(input);

      // Set the proxied URL
      form.action = action.replace(/^http(s|):\/\/.*/, window.FactlinkProxyConfig.PROXY_URL + '/submit/');
    } else {
      form.onsubmit = function(){return confirm("After submitting this form, Factlink will be disabled. Are you sure?");}
    }
  }

  top.document.title = document.title;

});

function scriptTag(url){
  var script = document.createElement("script");
  script.type = "text/javascript";
  script.async = false;
  script.src = url;
  return script;
}

// DUPLICATED IN CHROME EXTENSION, PLEASE CHANGE BOTH!
var script = scriptTag(window.FactlinkConfig.lib + (FactlinkProxyConfig.ENV === "development" ? "/factlink.js" : "/factlink.min.js"));
document.head.insertBefore(script, null);

})(window, document);
