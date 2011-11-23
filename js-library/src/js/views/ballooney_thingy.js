(function(Factlink, $, _, easyXDM, undefined) {

Factlink.set_position = function(top,left,window,el){
  function setLeft(el) {
    el.addClass('left');
    el.removeClass('right');
  }
  
  function setRight(el) {
    el.addClass('right');
    el.removeClass('left');
  }
  
  function setTop(el) {
    el.addClass('top');
    el.removeClass('bottom');
  }
  
  function setBottom(el) {
    el.addClass('bottom');
    el.removeClass('top');
  }
  
  var x = left, y = top;
  
  x -= 30;
  if ($(window).width() < (x + el.outerWidth(true) - $(window).scrollLeft())) {
    x = $(window).width() - el.outerWidth(true);
    
    setLeft(el);
  } else {
    if ( x < $(window).scrollLeft() ) {
      x = $(window).scrollLeft();
    }
    
    setRight(el);
  }
  
  y -= 6 + el.outerHeight(true);
  if (y < $(window).scrollTop()) {
    y = $(window).scrollTop() + el.outerHeight(true) + 14;
    
    setTop(el);
  } else {
    setBottom(el);
  }
  
  el.css({
    top: y + 'px',
    left: x + 'px'
  });
};
  
})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);