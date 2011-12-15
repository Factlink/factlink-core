(function(Factlink, $, _, easyXDM, undefined) {
    
Factlink.Balloon = function() {
  var id;
  var el;
  var hasFocus = false;
  var factObj;
  var timeout;
    
  function initialize(factId, fact) {
    id = factId;
    factObj = fact;
    
    Factlink.getTemplate("indicator", function() {
      initializeTemplate();
      
      bindCheck();
    });
  }
  
  this.show = function(top, left, fast) {
    window.clearTimeout(timeout);
    if (fast === true) {
      hideAll();
      el.show();
    }else{
      timeout = window.setTimeout(function() {
        hideAll();
        el.fadeIn('fast');
      }, 200);
    }
    Factlink.set_position(top,left,window,el);
    
    getChannels();
  };
  
  this.hide = function() {
    window.clearTimeout(timeout);
    
    el.fadeOut('fast');
    resetState();
  };
  
  this.isVisible = function() {
    return el.is(':visible');
  };
  
  this.destroy = function() {
    el.remove();
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
      },
      error: function(e) {
        ul.find('li.fl-loading').hide();
        if (e.message.status === 401) {
          ul.append('<li>Please <a href="' + FactlinkConfig.api + '/users/sign_in">login</a><br> to see your channels </li>');
        } else {
          ul.append('<li>There was an error retrieving your channels.</li>');
        }
      }
    });
  }
  
  function hideAll() {
    el.closest('#fl').find('.fl-popup').hide();
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
