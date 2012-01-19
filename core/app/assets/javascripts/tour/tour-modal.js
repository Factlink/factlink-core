(function(){
  var modal = $('#first-tour-modal').modal({backdrop: true});
  var hidden = true;

  modal.bind('hide', function() {
    hidden = true;
  }).bind('show', function() {
    hidden = false;
  });

  $('.take-the-tour').live('click', function() {
    modal.modal('show');

    // Load the tour
    $.ajax({
      url: "/tour",
      dataType: "html",
      success: function(data) {
        if ( !hidden ) {
          initTourModal(data);
        }
      }
    });
  });

  $('.hide-modal').live('click', function() {
    modal.modal('hide');
  });

  function initTourModal(data) {
    modal.html(data);

    initSlider(modal.find('.slider'));

    $('.bookmarklet').twipsy({placement:"below", offset:5});
  }

  function initSlider(el) {
    el.cycle({
      activePagerClass: "current",
    	fx:       "scrollHorz",
    	timeout:  0,
    	speed:    1000,
    	next: 	  ".next",
    	prev:     ".previous",
    	easing:   "easeOutSine",
    	nowrap: 1,
    	pause: 1,
    	pager:  "#pagerNav",

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

  function sliderSize() {
    return modal.find(".slider > div").length - 1;
  }

  function setButtonsForSlide(idx) {
    if (idx === 0) {
      // First page
      modal.find(".next").show();
      modal.find(".previous, .closeButton").hide();
    } else if (idx === sliderSize()) {
      // Last page
      modal.find(".next").hide();
      modal.find(".previous, .closeButton").show();
    } else {
      // Middle page
      modal.find(".previous, .next").show();
      modal.find(".closeButton").hide();
    }
  }
})();