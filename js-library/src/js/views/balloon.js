(function(Factlink, $, _, easyXDM, undefined) {
    
Factlink.Balloon = function() {
  var id;
  var el;
  var hasFocus = false;
  var factObj;
    
  function initialize(factId, fact) {
    id = factId;
    factObj = fact;
    
    Factlink.getTemplate("indicator", initializeTemplate);
    
    bindCheck();
  }
  
  function setLeft() {
    el.addClass('left');
    el.removeClass('right');
  }
  
  function setRight() {
    el.addClass('right');
    el.removeClass('right');
  }
  
  function setTop() {
    el.addClass('top');
    el.removeClass('bottom');
  }
  
  function setBottom() {
    el.addClass('bottom');
    el.removeClass('top');
  }
  
  this.show = function(top, left) {
    var x = left, y = top;
    
    el.fadeIn('fast');
    
    x -= 30;
    if ($(window).width() < (x + el.outerWidth(true) - $(window).scrollLeft())) {
      x = $(window).width() - el.outerWidth(true);
      
      setLeft();
    } else {
      if ( x < $(window).scrollLeft() ) {
        x = $(window).scrollLeft();
      }
      
      setRight();
    }
    
    y -= 6 + el.outerHeight(true);
    if (y < $(window).scrollTop()) {
      y = $(window).scrollTop() + el.outerHeight(true) + 14;
      
      setTop();
    } else {
      setBottom();
    }
    
    el.css({
      top: y + 'px',
      left: x + 'px'
    });
    
    getChannels();
  };
  
  this.hide = function() {
    el.fadeOut('fast');
    resetState();
  };
  
  this.isVisible = function() {
    return el.is(':visible');
  };
  
  function resetState() {
    el.removeClass("fl-channel-active");
  }
  
  function initializeTemplate(tmpl) {
    el = $(tmpl(factObj.getObject())).appendTo(Factlink.el);
    
    el.bind('mouseenter', function() {
      factObj.focus();
    }).bind('mouseleave', function() {
      factObj.blur();
    });
    
    el.find('div.fl-share').hoverIntent({
      over: function(e) {
        el.addClass('fl-channel-active');
      },
      out: function(e) {
        el.removeClass('fl-channel-active');
      },
      timeout: 500
    });
    
    el.find('div.fl-label').bind('click', function() {
      factObj.click();
    });
  }
  
  function getChannels() {
    var ul = el.find('ul.fl-channels');
    
    ul.find('li.fl-loading').show().siblings().remove();
    
    Factlink.get('/facts/' + id + '/channels.json',{
      dataType: "jsonp",
      jsonp: "callback",
      success: function(data) {
        ul.find('li.fl-loading').hide();
        if(_.isEmpty(data)) {
          ul.append("<li>You have no channels yet</li>");
        } 
        else {
          _.each(data, function(channel) {
            Factlink.getTemplate('channel_li', function(tmpl) {
              var $li = $(tmpl(channel));
              
              ul.append($li);
            });
          });
        }
      }
    });
  }
  
  function bindCheck() {
    el.delegate('ul.fl-channels :checkbox', 'change', function(e) {
      Factlink.post("/" + $(this).data('username') + "/channels/" + $(this).data('channel-id') + "/toggle/fact/" + id, {
        dataType: "script"
      });
    });
  }
  
  initialize.apply(this, arguments);
};

})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);
