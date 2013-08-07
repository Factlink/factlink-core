(function($){
  $.fn.infiniScroll = function(options) {
    var settings = {
      isFullyLoaded: function(){
        return false;
      },
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
    page = 1,
    $this = $(this);


    if (options) {
      settings = $.extend(settings, options);
    }

    // Load more items
    function load_more() {
      settings.start_loading.call(settings);
      var bool = false;
      try {
        bool = $this.is('div.evidence-list');
      } catch (e) {}

      if ( bool ) {
        var $current = $('div.tab_content:visible', this);

        page = parseInt( $current.data('page'), 10 );

        if ( !isNaN(page) ) {
          $current.data('page', page + 1);
          page += 1;
        } else {
          $current.data('page', 2);
          page = 2;
        }
      } else {
        page += 1;
      }

      Backbone.ajax({
        url: settings.url.call($this, page),
        dataType: 'script',
        success: function() {
          // Done loading!
          settings.stop_loading.call(settings);
        }
      });
    }

    $this.scroll(function() {
      if (!settings.isLoading && !settings.isFullyLoaded.call($this)) {
        // Check the scroll
        if ( settings.check_scroll.call($this) ) {
          load_more.call($this);
        }
      }
    });
  };
})($);
