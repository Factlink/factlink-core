window.Factlink = {}

# See http://stackoverflow.com/questions/3690447/override-default-jquery-selector-context
jQuery.noConflict()
window.$ = (selector, context) ->
  new jQuery.fn.init(selector, context or window.parent.document)

$.fn = $.prototype = jQuery.fn
jQuery.extend $, jQuery

if window.parent.easyXDM
  Factlink.easyXDM = window.parent.easyXDM.noConflict("FACTLINK")

# Create the Factlink container
Factlink.el = $("#fl")

# Prevent event bubbling outside our container
Factlink.el.on 'mouseup click', (event) -> event.stopPropagation()

# Add the stylesheet
$style = $("<link>").attr
  type: "text/css"
  rel: "stylesheet"
  href: FactlinkConfig.lib + "/css/basic.css?" + (new Date()).getTime()

$style.prependTo $("head")
