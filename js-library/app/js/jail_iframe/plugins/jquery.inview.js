/**
 * author Remy Sharp
 * url http://remysharp.com/2009/01/26/element-in-view-event-plugin/
 *
 * modified to support jq 2.0 by Eamon Nerbonne; changed API!
 */
(function ($) {
  var shouldCheckInView = false;

  function getViewportHeight() {
    var height = window.innerHeight; // Safari, Opera
    // if this is correct then return it. iPad has compat Mode, so will
    // go into check clientHeight (which has the wrong value).
    if (height) {
      return height;
    }
    var mode = document.compatMode;

    if ((mode || !$.support.boxModel)) { // IE, Gecko
      height = (mode == 'CSS1Compat') ?
          document.documentElement.clientHeight : // Standards
          document.body.clientHeight; // Quirks
    }

    return height;
  }

  function offsetTop(debug) {
    // Manually calculate offset rather than using jQuery's offset
    // This works-around iOS < 4 on iPad giving incorrect value
    // cf http://bugs.jquery.com/ticket/6446#comment:9
    var curtop = 0;
    for (var obj = debug; obj !== null; obj = obj.offsetParent) {
      curtop += obj.offsetTop;
    }
    return curtop;
  }

  var elems = [];

  function check_inview() {
    var vpH = getViewportHeight(),
        scrolltop = (window.pageYOffset ?
            window.pageYOffset :
            document.documentElement.scrollTop ?
                document.documentElement.scrollTop :
                document.body.scrollTop),
        new_elems = [];

    $(elems).each(function () {
      var $el = $(this),
          data = $el.data(),
          handler = data && data.inview_handler;

      if(!handler)
        return;
      new_elems.push(this);

      var top = offsetTop(this),
          height = $el.height(),
          inview = data.inview || false;

      if (scrolltop > (top + height) || scrolltop + vpH < top) {
        if (data.inview) {
          data.inview = false;
          handler(false);
        }
      } else if (scrolltop < (top + height)) {
        var visPart = ( scrolltop > top ? 'bottom' : (scrolltop + vpH) < (top + height) ? 'top' : 'both' );
        if (!data.inview || data.inview !== visPart) {
          data.inview = visPart;
          handler(true, visPart);
        }
      }
    });
    elems = new_elems;
  }

  $.fn.inview = function (handler) {
    return this.data('inview_handler', handler).each(function (___, el) {
      elems.push(el);
    });
  }

  function triggerInViewChecker() {
    shouldCheckInView = true;
  }

  $(window).scroll(triggerInViewChecker);
  $(window).resize(triggerInViewChecker);
  $(window).click(triggerInViewChecker);
  // kick the event to pick up any elements already in view.
  // note however, this only works if the plugin is included after the elements are bound to 'inview'
  $(window).ready(triggerInViewChecker);

  // Check every 100 milliseconds if a scroll/click/resize/ready event is triggered
  // Source: http://ejohn.org/blog/learning-from-twitter/
  setInterval(function () {
    if (shouldCheckInView) {
      shouldCheckInView = false;

      check_inview();
    }
  }, 100);
})(jQuery);
