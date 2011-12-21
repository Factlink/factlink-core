//= require jquery.cycle.all
//= require jquery.easing.1.3

$('#first-tour-modal').modal({backdrop: true});
$('#first-tour-modal').modal('show');

$('.bookmarklet').twipsy({placement:"below",offset:5});

function sliderSize() {
  return $("#slider > div").length - 1;
}

function setButtonsForSlide(idx) {  
  if (idx === 0) {
    // First page
    $("#next").show();
    $("#previous, #close").hide();
  } else if (idx === sliderSize()) {
    // Last page
    $("#next").hide();
    $("#previous, #close").show();    
  } else {
    // Middle page
    $("#previous, #next").show();
    $("#close").hide();
  }
}

$('#slider').cycle({
  activePagerClass: "current",
	fx:       "scrollHorz",
	timeout:  0, 
	speed:    1000,
	next: 	  "#next",
	prev:     "#previous", 
	easing:   "easeOutSine",
	nowrap: 1,
	pause: 1,
	pager:  "#pagerNav",
	before: function(current_slide) {
	},
	
  // callback fn that creates a thumbnail to use as pager anchor 
  pagerAnchorBuilder: function(idx, slide) {
    var title = $(slide).data('title');
    return '<li><a href="#">' + title + '</a></li>'; 
  },
  
  onPagerEvent: function(zeroBasedSlideIndex) {
    setButtonsForSlide(zeroBasedSlideIndex);
  },
  onPrevNextEvent: function(isNext, zeroBasedSlideIndex, slideElement) {
    setButtonsForSlide(zeroBasedSlideIndex);
  }
});