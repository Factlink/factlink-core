(function($) {
  var Wheel = (function() {
    function Wheel(fact, params) { 
      this.fact = fact;
      this.opinions = $(fact).find(".opinion"); 
      this.relevance = $(fact).find(".relevance_opinion");
      this.params = $.extend(params,{"dim": 24, "default_stroke": {"opacity": 0.2, "stroke": 9}, "hover_stroke": {"opacity": 0.6, "stroke": 11}}); 
    }
    Wheel.prototype.calc_display = function (opinions) { 
      var remainder = 100;
			$(opinions).each(function() {
				var display_value = $(this).data("value");
				// NOTE: this way the total is *not* always 100! (consider 70, 20, 10)
				// TODO fix this!
				display_value = (display_value < 15 ? 15 : display_value);
				display_value = (display_value > 70 ? 70 : display_value);
				remainder = remainder - display_value;
				this.display_value = display_value;
			});        					
			var leng = opinions.length;
			$(opinions).each(function() { // Add remainder
				this.display_value = this.display_value + (remainder / leng) ;
			});
    }  
    Wheel.prototype.set_opinions = function (opinions, offset, size, total_degrees) {
        var w = this;
        var total = 0;
        w.calc_display(opinions);
        $(opinions).each(function() {  // HACK, see above NOTE/TODO
  				total = total + this.display_value;
  			});    
        $(opinions).each(function() { 
          var value = this.display_value;
  				offset = offset + value;
  				var opacity = $(this).data("user-opinion") ? 1.0 : w.params.default_stroke.opacity,
  				z = w.r.path().attr({arc: [value - 2, total, (total_degrees / total * offset), size, total_degrees]})
          .attr({stroke : $(this).data("color"), "stroke-width": w.params.default_stroke.stroke, opacity: opacity}); 
          this.raphael = z;
        })
        w.r.set;
    }
    Wheel.prototype.bind_events = function( el ) { 
      var w = this;
      $(el).each(function() {
        // bind events
        var $t = $(this);
        var op = $t.data("user-opinion");
  			this.raphael.mouseover(function(){
  				if(!$t.data("user-opinion")) {
  					this.animate({ 'stroke-width': w.params.hover_stroke.stroke, opacity: w.params.hover_stroke.opacity }, 200, '<>');
  				} else {
  					this.animate({ 'stroke-width': w.params.hover_stroke.stroke }, 200, '<>');    
  				}
  			});
  			this.raphael.mouseout(function(){ 
  				if(!$t.data("user-opinion")) { 
  					this.stop().animate({ 'stroke-width': w.params.default_stroke.stroke, opacity: w.params.default_stroke.opacity }, 200, '<>') 
  				} else {
  					this.animate({ 'stroke-width': w.params.default_stroke.stroke }, 200, '<>');    
  				}
  				});
        $(this.raphael.node).bind("click", function() { 
          $(w.fact).factlink("switch_opinion", $t);
        });
        $(this.raphael.node).hoverIntent({
  				over: function() {
  					optionBox = $(w.fact).find("." +  $t.data("opinion") + "-box");
  					$(optionBox).css({"top" : $(this).position().top, "left" : parseInt($(this).position().left) + 25 + "px"}).fadeIn("fast");
  				},
  				out: function() {
  					$(w.fact).find("." + $t.data("opinion") + "-box").delay(600).fadeOut("fast");				
  				}	
  			});
		  });
    }
    
    Wheel.prototype.init = function (canvas) {
      var w = this;
      w.r = Raphael(canvas, w.params.dim*2+17, w.params.dim*2+17); // was 45,45
      w.r.customAttributes.arc = function (value, total, start, R, total_degrees, size) {
        alpha = total_degrees / total * value,
        a = (start - alpha) * Math.PI / 180, b = start * Math.PI/180,
        dim = w.params.dim + 6,
        sx = dim + R * Math.cos(b), sy = dim - R * Math.sin(b),
        x = dim + R * Math.cos(a), y = dim - R * Math.sin(a),
        path = [['M', sx, sy], ['A', R, R, 0, +(alpha > 180), 1, x, y]];                  
        return {path: path};
      }
      
      w.set_opinions(this.opinions, 0, 14, 360);
      w.set_opinions(this.relevance, 50, 25, 180);
      
      w.bind_events($.merge(this.opinions, this.relevance));

    }
    return Wheel;
  })();
  
	var methods = {
		// Initialize factbubble
		init : function(options) {
			return this.each(function() {
				var $t = $(this);
				if(!$t.data("initialized")) {
					$t.find(".evidence-facts a.show-evidence").live("click", function() { 
						$t.find(".evidence-container").slideToggle();
						return false;
					});
          $t.find(".shaw-add").live("click", function() { 
            $t.find(".evidence-container").slideToggle();
						toggleEvidenceLabel();
						return false;
          });
					$t.find(".add-action a#toggle-show-add").live("click", function() {
						toggleEvidenceLabel();
						return false;
					});					
					function toggleEvidenceLabel() { 
					  $t.find(".evidence").toggle();
						$t.find(".potential-evidence").toggle();
						$t.find(".add-action.do-add").toggle();
						$t.find(".add-action.do-show").toggle();
					}
					$t.data("initialized", true);
				}
				// Prevents boxes from dissapearing on mouse over
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
					switch_opinion : function ( opinion ) { 
					  var op = opinion;
					  var fact = this; 
					  this.data("wheel").opinions.each(function() { 
					    var current_op = this;
					    if($(current_op).data("opinion") == op.data("opinion")) { // The clicked op is the current op in the list
      					if(!$(current_op).data("user-opinion")) {
      						$.post("/fact/" + $(fact).data("fact-id") + "/opinion/" + op.data("opinion"),
      						function() { 
                    $(current_op).data("user-opinion", true);
                    current_op.raphael.animate({opacity: 1},200);
      						});
      					} else {
      						$.ajax({
      							type: "DELETE",
      							url: "/fact/" + $(fact).data("fact-id") + "/opinion/",
      							success: function(msg){
                      $(current_op).data("user-opinion", false);
                      current_op.raphael.animate({opacity: 0.2},200); 
      							}
      						});
      					}
					    } else { // The clicked op is not the current op
					      this.raphael.animate({opacity: 0.2},200);
					      $(this).data("user-opinion", false);
					    }
					  });
					  this.data("wheel").bind_events();
					},
					
					// Channels
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
            
            $t.data("wheel", new Wheel(fact)); 
            $t.data("wheel").init($t.find(".wheel").get(0));
            
						$t.find("a.add-to-channel").hoverIntent(
							function() {
								channelList = $t.find(".channel-listing");
								$(channelList).css({"top" : parseInt($(this).position().top) + 20 + "px", "left" : parseInt($(this).position().left) + 10 + "px"}).fadeIn("fast");
							},	
							function() {
								$t.find(".channel-listing").delay(600).fadeOut("fast");				
							}
						);
						$t.find(".opinion-box").find("img").tipsy({gravity: 's'});
						$t.data("initialized", true);
					}
				}
		  })(jQuery);