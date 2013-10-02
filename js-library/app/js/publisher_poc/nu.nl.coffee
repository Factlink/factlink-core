# Please note: This is a Proof of Concept to be used for user testing.
# This really needs clean up before we are actually going to use this.

`/*!
  * $script.js Async loader & dependency manager
  * https://github.com/ded/script.js
  * (c) Dustin Diaz 2013
  * License: MIT
  */
(function(e,t,n){typeof module!="undefined"&&module.exports?module.exports=n():typeof define=="function"&&define.amd?define(n):t[e]=n()})("$script",this,function(){function v(e,t){for(var n=0,r=e.length;n<r;++n)if(!t(e[n]))return f;return 1}function m(e,t){v(e,function(e){return!t(e)})}function g(e,t,a){function d(e){return e.call?e():r[e]}function b(){if(!--p){r[h]=1,c&&c();for(var e in s)v(e.split("|"),d)&&!m(s[e],d)&&(s[e]=[])}}e=e[l]?e:[e];var f=t&&t.call,c=f?t:a,h=f?e.join(""):t,p=e.length;return setTimeout(function(){m(e,function(e){if(e===null)return b();if(u[e])return h&&(i[h]=1),u[e]==2&&b();u[e]=1,h&&(i[h]=1),y(!n.test(e)&&o?o+e+".js":e,b)})},0),g}function y(n,r){var i=e.createElement("script"),s=f;i.onload=i.onerror=i[d]=function(){if(i[h]&&!/^c|loade/.test(i[h])||s)return;i.onload=i[d]=null,s=1,u[n]=2,r()},i.async=1,i.src=n,t.insertBefore(i,t.firstChild)}var e=document,t=e.getElementsByTagName("head")[0],n=/^https?:\/\//,r={},i={},s={},o,u={},a="string",f=!1,l="push",c="DOMContentLoaded",h="readyState",p="addEventListener",d="onreadystatechange";return!e[h]&&e[p]&&(e[p](c,function b(){e.removeEventListener(c,b,f),e[h]="complete"},f),e[h]="loading"),g.get=y,g.order=function(e,t,n){(function r(i){i=e.shift(),e.length?g(i,r):g(i,t,n)})()},g.path=function(e){o=e},g.ready=function(e,t,n){e=e[l]?e:[e];var i=[];return!m(e,function(e){r[e]||i[l](e)})&&v(e,function(e){return r[e]})?t():!function(e){s[e]=s[e]||[],s[e][l](t),n&&n(i)}(e.join("|")),g},g.done=function(e){g([null],e)},g})
`
$script(['//code.jquery.com/jquery-1.10.2.min.js',
         '//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.5.2/underscore-min.js',
         "#{window.FactlinkConfig.lib}/factlink_loader_basic.#{window.FactlinkConfig.minified}js"
         ], 'myBundle')

$script.ready 'myBundle', ->
  factlink_publisher = new FactlinkPublisher
  factlink_publisher.addFactlinkButtons()

  FACTLINK.on 'factlink.factsLoaded', (facts) ->
    ui = new UI
    ui.updateFactsCount facts.length
    ui.bindActions()

  FACTLINK.startHighlighting()

class FactlinkPublisher

  addFactlinkButtons: ->
    $(@button()).appendTo $('.socialsprite')

    $(".socialshare li").eq(1).remove() # delete email button
    $(".socialshare li").eq(0).after @buttonWithCount()

  button: =>
    html = """
      <li onclick="FACTLINK.triggerClick();" class="fl-button-container">
        <img src="https://factlink.com/favicon.ico" height="24" width="24">
      </li>
      <div class="fl-help-text fl-button-help-text">
        <img src="https://factlink.com/favicon.ico" height="24" width="24">
        <p>Select any statement in this article and click this button to add your opinion.</p>
      </div>
    """
    button = $(html)

    button.mouseenter ->
      $('.fl-button-help-text').show()
    button.mouseleave ->
      $('.fl-button-help-text').hide()

    button

  buttonWithCount: ->
    html = """
    <li class="fl-button-with-count-container">
      <div class="fl-overlay-scroll-button"></div>
      <img src="https://factlink.com/favicon.ico" class="fl-overlay-annotate-button"> <!-- Use invisble image to precent losing selection when clicking -->

      <div class="fl-fact-count-container">

        <div class="fl-fact-count">0</div>

        <div id="Factlink_bubble_nub">
          <s></s>
          <i></i>
        </div>
      </div>

      <div class="fl-factlink-identity">
        <img src="https://factlink.com/favicon.ico" height="14" width="14">
        Factlink
      <div>
    </li>

    <div class="fl-help-text fl-button-with-count-help-text">
      <img src="https://factlink.com/favicon.ico" height="24" width="24">
      <p>Select any statement in this article and click this button to add your opinion.</p>
    </div>
    """
    button_with_count = $(html)

    button_with_count.find('.fl-overlay-annotate-button').on 'mouseenter', ->
      $('.fl-button-with-count-help-text').show()
    button_with_count.find('.fl-overlay-annotate-button').on 'mouseleave', ->
      $('.fl-button-with-count-help-text').hide()

    button_with_count

class UI
  updateFactsCount: (count) ->
    $('.fl-fact-count').text count

  bindActions: ->
    $('.fl-overlay-scroll-button').on 'click', ->
      fact_id = $('.factlink.fl-first').first().data("factid")
      FACTLINK.scrollTo fact_id if fact_id

    $('.fl-overlay-annotate-button').on 'click', ->
      FACTLINK.triggerClick()
