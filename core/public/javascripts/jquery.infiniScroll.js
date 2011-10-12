(function($){
  $.fn.infiniScroll = function(options) {
    var settings = {
      isFullyLoaded: false,
      check_scroll: function() {
        if ($(document).height() - ($(window).scrollTop() + $(window).height()) < 700) {
          return true;
        }
      },
      start_loading: function() {
        this.isLoading = true;
      },
      stop_loading: function() {
        this.isLoading = false;
      },
      // Are we currently loading?
      isLoading: false
    },
    // Integer value holding current page number
    page = 1,
    $this = $(this);


    if (options) {
      settings = $.extend(settings, options);
    }

    // Load more items
    function load_more() {
      settings.start_loading.call(settings);

      page++;

      $.ajax({
        url: settings.url(page),
        dataType: 'script',
        success: function() {
          // Done loading!
          settings.stop_loading.call(settings);
        }
      });
    }

    $this.scroll(function() {
      if (!settings.isLoading && !settings.isFullyLoaded()) {
        // Check the scroll
        if ( settings.check_scroll.call($this) ) {
          load_more();
        }
      }
    });
  };
})($);