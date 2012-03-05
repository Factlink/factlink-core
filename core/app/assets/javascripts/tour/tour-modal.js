$(function(){
  
  function Modal(opts) {
    var self = this;
    var opts = $.merge(opts, {});
    
    self.show = function show () {
      console.info( "Modal:", "Show");
      $.ajax({
        url: "/tour",
        dataType: "html",
        success: function () {
          init.apply(this, arguments);
          
          opts.el.modal('show');
        }
      });
    };
    
    self.hide = function hide () {
      console.info( "Modal:", "Hide");
      opts.el.modal('hide');
    };
    
    if (opts.showActionEl) {
      opts.showActionEl.live('click', function() {
        try {
          mpmetrics.track("Take The Tour: Click", {
            where: "topbar"
          });
        } catch(e) {}
        
        self.show();
      });
    }
    
    if (opts.hideActionEl) {
      opts.hideActionEl.live('click', function() {
        try {
          mpmetrics.track("Take The Tour: Hide", {
            where: "cross"
          });
        } catch(e) {}
        
        self.hide();
      });
    }
    
    function init(html) {
      opts.el.html(html);

      initCycle();

      // TODO: Fix the tooltip.
      // opts.el.find('.slider').find('.bookmarklet')
      //   .tooltip({placement:"below", offset:5});
    }
    
    function sliderSize() {
      return opts.el.find(".slider > div").length - 1;
    }

    function setButtonsForSlide(idx) {
      if (idx === 0) {
        // First page
        opts.el.find(".next").show();
        opts.el.find(".previous, .closeButton").hide();
      } else if (idx === sliderSize()) {
        // Last page
        opts.el.find(".next").hide();
        opts.el.find(".previous, .closeButton").show();
      } else {
        // Middle page
        opts.el.find(".previous, .next").show();
        opts.el.find(".closeButton").hide();
      }
    }
    
    function initCycle() {
      opts.el.find('.slider').cycle({
        activePagerClass: "current",
        fx:       "scrollHorz",
        timeout:  0,
        speed:    1000,
        next:     ".next",
        prev:     ".previous",
        easing:   "easeOutSine",
        nowrap: 1,
        pause: 1,
        pager:  "#pagerNav",

        after: function(currSlideElement, nextSlideElement, options, forward) {
          try {
            mpmetrics.track("Take The Tour: Slide", {
              type: (forward ? "forward" : "backward")
            });
          } catch(e) {}
        },

        // callback fn that creates a thumbnail to use as pager anchor
        pagerAnchorBuilder: function(idx, slide) {
          var title = $(slide).data('title');
          return '<li><a>' + title + '</a></li>';
        },

        onPagerEvent: function(zeroBasedSlideIndex) {
          setButtonsForSlide(zeroBasedSlideIndex);
        },
        onPrevNextEvent: function(isNext, zeroBasedSlideIndex, slideElement) {
          setButtonsForSlide(zeroBasedSlideIndex);
        }
      });
    }
    return self;
  }
  
  window.Tour = new Modal({
    el: $('#first-tour-modal'),
    showActionEl: $('a.take-the-tour'),
    hideActionEl: $('.hide-modal')
  });
});