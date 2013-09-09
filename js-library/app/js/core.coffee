window.Factlink = {}

Factlink.global = window.parent

# See http://stackoverflow.com/questions/3690447/override-default-jquery-selector-context
jQuery.noConflict()
window.$ = (selector, context) ->
  new jQuery.fn.init(selector, context or Factlink.global.document)

$.fn = $.prototype = jQuery.fn
jQuery.extend $, jQuery

if Factlink.global.easyXDM
  Factlink.global.FACTLINK = {}
  Factlink.easyXDM = Factlink.global.FACTLINK.easyXDM = Factlink.global.easyXDM.noConflict("FACTLINK")

# Create the Factlink container
Factlink.el = $("#fl")

# Create template wrapper
Factlink.tmpl = {}

# Add the stylesheet
$style = $("<link>").attr
  type: "text/css"
  rel: "stylesheet"
  href: FactlinkConfig.lib + "/css/basic.css?" + (new Date()).getTime()

$style.prependTo $("head")
