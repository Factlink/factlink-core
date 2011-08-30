(function($) {
  
  var methods = {
    // Initialize factbubble
    init : function(options) {
      return this.each(function() {
        var $t = $(this);
        $t.find(".evidence-facts a.show-evidence").click(function() { 
  				if ($t.find(".evidence-container").is(":hidden")) {
  					$t.find(".evidence-container").slideDown();
  				} else {
  					$t.find(".evidence-container").slideUp();
  				}
  				return false;
  			});
  			
  			// Prevents boxes from dissapearing when mouse over
    	  $t.find(".float-box").mouseover(
  				function() { 	    
  					$(this).stop(true, true).css({"opacity" : "1"}); 
  					}).mouseout(
  				function() { 
  					$(this).delay(500).fadeOut("fast"); 
  			});
        // For each fact bubble
  	    $t.find("article.fact").each(function() { 
            init_fact(this);
  			});  
			});
    },
    fact : function( fact ) { init_fact(fact) },
    get : function( id ) {
      $.ajax({
        url: "/fact/" + parseInt(id),
        dataType: "html",
        type: "GET",
        success: function(data) { 
          
        },
        error: function(error) { 
          console.log(error); // Not very secure, but better than just failing
        }
      })
    },
    // TODO
    hide : function( ) { },
    update : function( content ) { },
    // Toggles channel
    to_channel : function ( user, channel, fact ) { 
    	$.ajax({
				url: "/" + user + "/channels/toggle/fact",
				dataType: "script",
				type: "POST",
				data: {
				  user: user,
					channel_id: channel,
					fact_id: fact
				}
			});  
    },
    add_evidence : function ( evidence ) { },
    set_opinion : function ( opinion ) { },
  };
  
	$.fn.factlink = function(method) {
	   // Method calling logic
      if ( methods[method] ) {
        return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
      } else if ( typeof method === 'object' || ! method ) {
        return methods.init.apply( this, arguments );
      } else {
        $.error( 'Method ' +  method + ' does not exist on jQuery.factlink' );
      }    
	}
  // Private functions
  function init_fact(fact) {
    var $t = $(fact);
    if(!$t.data("initialized")) {
  	  $t.opinions = create_opinions($t);
  	  create_wheel($t, $t.opinions);  
  	  $t.find("a.add-to-channel").hoverIntent(
  	    function() {
  				channelList = $t.find(".channel-listing");
  				$(channelList).css({"top" : $(this).position().top, "left" : parseInt($(this).position().left) + 20 + "px"}).fadeIn("fast");
  			},	
  			function() {
  			  $t.find(".channel-listing").delay(600).fadeOut("fast");				
  			}
  	  );
  	  $t.find(".opinion-box").find("img").tipsy({gravity: 's'});
  	  $t.data("initialized", true);
    }
  }
  
  function set_opinion(fact, opinion) { 
    if(!is_user_opinion(fact, opinion)) {
      $.post("/fact/" + $(fact).data("fact-id") + "/opinion/" + opinion,
      function() { 
        $(fact).data("user-opinion", opinion);
        $(fact.opinions).each(function() { 
          if(!is_user_opinion(fact, this.opinion)) {
            this.raphael.animate({opacity: 0.2},"200");
          } else {
            this.raphael.animate({opacity: 1},200);
          }});
      });
    } else {
      $.ajax({
        type: "DELETE",
        url: "/fact/" + $(fact).data("fact-id") + "/opinion/",
        success: function(msg){
          $(fact).data("user-opinion", " ");
            $(fact.opinions).each(function() { 
              this.raphael.animate({opacity: 0.2},200);
            });
          }
      });
  }};

  function is_user_opinion(fact, opinion) { 
	  return $(fact).data("user-opinion") == opinion;
	}
	
	function create_opinions(fact) { 
	  var opinions = [],
        remainder = 100;
    $(fact).find(".opinion").each(function(i) {
      var display_value = $(this).data("value");
      display_value = (display_value < 15 ? 15 : display_value);
      display_value = (display_value > 70 ? 70 : display_value);
      remainder = remainder - display_value;
      opinions.push({opinion: $(this).data("opinion"), value: $(this).data("value"), element: this, display_value: display_value});
    });
    
    $(opinions).each(function() {
      this.display_value = this.display_value + (remainder / opinions.length);
    });
    return opinions;
	}
	
	function create_wheel(fact, opinions) {
    var wheel_id = $(fact).find(".wheel").get(0),
        r = Raphael(wheel_id, 45, 45);
    r.customAttributes.arc = function (value, total, start, R) {
        alpha = 360 / total * value,
        a = (start - alpha) * Math.PI / 180,
    		b = start * Math.PI/180,
    		dim = 20,
    		sx = dim + R * Math.cos(b),
    		sy = dim - R * Math.sin(b),
    		x = dim + R * Math.cos(a),
    		y = dim - R * Math.sin(a),
        path = [['M', sx, sy], ['A', R, R, 0, +(alpha > 180), 1, x, y]];
        return {path: path};
    };  
    var total = 100, offset = 0;
    $(opinions).each(function(i) { 
      var value = this.display_value;
      offset = offset + value;
      var opinion = this.opinion,
          opacity = is_user_opinion(fact, opinion) ? 1.0 : 0.2,
          z = r.path().attr({arc: [value - 2, total, (360 / total * offset), 14]})
                      .attr({stroke : $(this.element).data("color"), "stroke-width": 9, opacity: opacity});
      this.raphael = z;
      
      // bind events
      z.mouseover(function(){ 
        if(!is_user_opinion(fact, opinion)) {
          this.animate({ 'stroke-width': 11, opacity: .6 }, 1000, 'elastic');
        } else {
          this.animate({ 'stroke-width': 11 }, 1000, 'elastic');    
        }
      }).
        mouseout(function(){ 
          if(!is_user_opinion(fact, opinion)) { 
            this.stop().animate({ 'stroke-width': 9, opacity: 0.2 }, 1000, 'elastic') 
          } else {
              this.animate({ 'stroke-width': 9 }, 1000, 'elastic');    
          }
      }).click(function() { set_opinion(fact, opinion); });      
      $(z.node)
        .hoverIntent({
  				over: function() {
  					optionBox = $(fact).find("." + opinion + "-box");
  					$(optionBox).css({"top" : $(this).position().top, "left" : parseInt($(this).position().left) + 25 + "px"}).fadeIn("fast");
  				},
  				out: function() {
  				  $(fact).find("." + opinion + "-box").delay(600).fadeOut("fast");				
  				}	
      });        			
    });
    r.set();
  };
})(jQuery);