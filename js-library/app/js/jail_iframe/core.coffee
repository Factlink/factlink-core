window.FactlinkJailRoot =
  $.extend(
    can_haz: {}
    core_loaded_promise: $.Deferred()
    host_ready_promise: $.Deferred()
    host_loaded_promise: $.Deferred()
  , window.Events);

# See http://stackoverflow.com/questions/3690447/override-default-jquery-selector-context
jQuery.noConflict()
window.$ = (selector, context) ->
  new jQuery.fn.init(selector, context || window.parent.document)

window.parent.FACTLINK_JQUERY = window.$

$.fn = $.prototype = jQuery.fn
jQuery.extend $, jQuery

# Create the FactlinkJailRoot container
FactlinkJailRoot.$factlinkCoreContainer = $("#factlink-containment-wrapper")
