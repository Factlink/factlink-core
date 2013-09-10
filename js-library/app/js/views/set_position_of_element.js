Factlink.set_position_of_element = function(top,left,window,el){
  function setLeft(element) {
    element.addClass('left');
    element.removeClass('right');
  }

  function setRight(element) {
    element.addClass('right');
    element.removeClass('left');
  }

  function setTop(element) {
    element.addClass('top');
    element.removeClass('bottom');
  }

  function setBottom(element) {
    element.addClass('bottom');
    element.removeClass('top');
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
