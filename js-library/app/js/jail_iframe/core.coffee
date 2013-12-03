window.FactlinkJailRoot = $.extend({ can_haz: {}}, window.Events);

# See http://stackoverflow.com/questions/3690447/override-default-jquery-selector-context
jQuery.noConflict()
window.$ = (selector, context) ->
  new jQuery.fn.init(selector, context or window.parent.document)

$.fn = $.prototype = jQuery.fn
jQuery.extend $, jQuery

# Create the FactlinkJailRoot container
FactlinkJailRoot.$factlinkCoreContainer = $("#fl")
