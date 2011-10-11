(function($) {
  var Wheel = (function() {
    function Wheel(fact, params) {
      this.fact = fact;
      this.opinions = $(fact).find(".opinion");
      this.authority = $(fact).find(".authority").first();
      this.params = $.extend(params, {
        "dim": 24,
        "radius" : 18,
        "default_stroke": {
          "opacity": 0.2,
          "stroke": 9
        },
        "hover_stroke": {
          "opacity": 0.5,
          "stroke": 11
        }
      });
    }

    function arc(w, op, p) {
      var opacity = $(op).data("user-opinion") ? 1.0 : w.params.default_stroke.opacity;
      if (!op.raphael) {
        // set new path
       var z = w.r.path().attr({
          arc: [op.display_value - 2, p.total, (p.total_degrees / p.total * p.offset), p.r, p.total_degrees],
          stroke: $(op).data("color"),
          "stroke-width": w.params.default_stroke.stroke,
          opacity: opacity
        });
        op.raphael = z;
        return z;
      } else {
        return op.raphael.animate({
          arc: [op.display_value - 2, p.total, (p.total_degrees / p.total * p.offset), p.r, p.total_degrees],
          opacity: opacity
        }, 200, '<>');
      }
    }
    
    function authority(w, authority) { 
      var auth = authority.data("authority");
      var pos = w.params.dim + (w.params.dim * 0.25);
      if (!authority.raphael) {
        var z = w.r.text(pos, pos, auth).attr({"font-size" : "13px", "fill" : "#ccc"});
        authority.raphael = z;
        return z;
      } else { 
        return authority.raphael.attr({"text": auth});
      }
    }

    Wheel.prototype.calc_display = function(opinions) {
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
      $(opinions).each(function() {
        // Add remainder
        this.display_value = this.display_value + (remainder / leng);
      });
    };

    Wheel.prototype.set_opinions = function(opinions, offset, r, total_degrees) {
      var w = this;
      var total = 0;
      var a = authority(w, w.authority);
      w.calc_display(opinions);
      
      $(opinions).each(function() {
        // HACK, see above NOTE/TODO
        total = total + this.display_value;
      });
      $(opinions).each(function() {
        offset = offset + this.display_value;
        var z = arc(w, this, {
          offset: offset,
          val: this.display_value,
          total: total,
          total_degrees: total_degrees,
          r: r
        });
      });
    };

    Wheel.prototype.update = function() {
      var w = this;
      w.set_opinions(w.opinions, 0, w.params.radius, 360);
    };

    Wheel.prototype.bind_events = function(op) {
      var w = this;
      $(op).each(function() {
        // bind events
        var $t = $(this);
        this.raphael.mouseover(function() {
          if (!$t.data("user-opinion")) {
            this.animate({
              'stroke-width': w.params.hover_stroke.stroke,
              opacity: w.params.hover_stroke.opacity
            }, 200, '<>');
          } else {
            this.animate({
              'stroke-width': w.params.hover_stroke.stroke
            }, 200, '<>');
          }
        });
        this.raphael.mouseout(function() {
          if (!$t.data("user-opinion")) {
            this.stop().animate({
              'stroke-width': w.params.default_stroke.stroke,
              opacity: w.params.default_stroke.opacity
            }, 200, '<>');
          } else {
            this.animate({
              'stroke-width': w.params.default_stroke.stroke
            }, 200, '<>');
          }
        });
        $(this.raphael.node).bind("click", function() {
          $(w.fact).factlink("switch_opinion", $t);
        });
        $(this.raphael.node).hoverIntent({
          over: function(e) {
            optionBox = $(w.fact).find("." + $t.data("opinion") + "-box");
            $(optionBox).fadeIn("fast");

          },
          out: function() {
            $(w.fact).find("." + $t.data("opinion") + "-box").delay(500).fadeOut("fast");
          }
        });
      });
    };

    Wheel.prototype.init = function(canvas) {
      var w = this;
      w.r = Raphael(canvas, w.params.dim * 2 + 17, w.params.dim * 2 + 17);
      // was 45,45
      w.r.customAttributes.arc = function(value, total, start, R, total_degrees, size) {
        var alpha = total_degrees / total * value,
            a = (start - alpha) * Math.PI / 180,
            b = start * Math.PI / 180,
            dim = w.params.dim + 6,
            sx = dim + R * Math.cos(b),
            sy = dim - R * Math.sin(b),
            x = dim + R * Math.cos(a),
            y = dim - R * Math.sin(a),
            path = [
            ['M', sx, sy],
            ['A', R, R, 0, +(alpha > 180), 1, x, y]
            ];
        return {
          path: path
        };
      };
      w.set_opinions(this.opinions, 0, w.params.radius, 360);
      w.bind_events(this.opinions);
    };
    return Wheel;
  })();

  var methods = {
    // Initialize factbubble
    init: function(options) {
      return this.each(function() {
        function stop_fade(t) {
          t.stop(true, true).css({
            "opacity": "1"
          });
        }
        function switchTabAction(active) { 
          $t.find(".tab_content[rel=" + active + "] .add-evidence").toggle();
          $t.find(".tab_content[rel=" + active + "] .evidence").toggle();
          var action = $t.find(".add-action[rel=" + active + "] > a"); 
          action.text($(action).text() === 'Add facts' ? 'Show facts' : 'Add facts');
        }
        function addEventHandlersDoAdd($t){
          $t.find("a.do-add").bind("click", function() { 
            var active = $t.find(".tab_content:visible").attr("rel");
            $t.trigger("factlink:switchTabAction", [active]);
          }); 
        }
        function addEventHandlersTabs($t){
          $t.find("ul.evidence li").click(function() {
            $t.find(".tab_content, div.add-action").hide(); 
            var activeTab = $(this).find("a").attr("class"); 
            $t.find(".tab_content[rel='" + activeTab + "']").show();
            $t.find("div.add-action[rel='" + activeTab + "']").show();
            if($t.find(".evidence-container").is(":hidden")) { 
              $t.find(".evidence-container").slideDown();
              $(this).addClass("active"); 
            } else { 
              if($(this).hasClass("active")) { 
                $t.find(".evidence-container").slideUp(function() {
                  $t.find("ul.evidence li").removeClass("active");
                }); 
              } else { 
                $t.find("ul.evidence li").removeClass("active"); 
                $(this).addClass("active");
              }
            }
              return false;
           });
         }
        function initialize($t) {
          /* based on http://www.sohtanaka.com/web-design/simple-tabs-w-css-jquery/ */
          //On Click Event
          addEventHandlersTabs($t);
          addEventHandlersDoAdd($t);
          $t.bind("factlink:switchTabAction", function(e, active)  {
            switchTabAction(active); 
          });
          // Evidence buttons
          $t.find(".existing_evidence a").live("ajax:complete", function(et, e){
            $(this).closest('ul').children().removeClass("active");
            $(this).parent().addClass('active');
           });
           $t.data("initialized", true);
        }
        /*start of method*/
        var $t = $(this);
        $t.data("facts",  {});
        if (!$t.data("initialized")) {
            initialize($t);
        }
        $t.find("article.fact").each(function() {
          var fact = init_fact(this, $t);
          $t.data("facts")[fact.attr("data-fact-id")] = fact;

        });

        // Prevents boxes from dissapearing on mouse over
        $t.find(".float-box").mouseover(function() { stop_fade($(this)); });
        $t.find(".float-box").mouseout(function() {
          if(!$(this).find("input#channel_title").is(":focus")) {
            $(this).delay(500).fadeOut("fast");
          }
        });
      });
    },
    // Update
    update: function(data) {
      var $t = $(this).data("container") || $(this);
      if($t.data("initialized")) { 
       $(data).each(function() { 
          var fact =  $t.data("facts")[this.id];
          if(fact && $(fact).data("initialized")) { 
            $(fact).data("update")(this.score_dict_as_percentage); // Update the facts
          }
       });
      }
    },
    switch_opinion: function(opinion) {
      var fact = this,
          opinions = fact.data("wheel").opinions;
      opinions.each(function() {
        var current_op = this;
        if ($(current_op).data("opinion") === opinion.data("opinion")) {
          // The clicked op is the current op in the list
          if (!$(current_op).data("user-opinion")) {
            $.post("/fact_item/" + $(fact).data("fact-id") + "/opinion/" + opinion.data("opinion"), function(data) {
              data_attr(current_op, "user-opinion", true);
              fact.factlink("update", data);
            });
          }
          else {
            $.ajax({
              type: "DELETE",
              url: "/fact_item/" + $(fact).data("fact-id") + "/opinion/",
              success: function(data) {
                data_attr(current_op, "user-opinion", false);
                fact.factlink("update", data);
              }
            });
          }
        }
        else {
          data_attr(current_op, "user-opinion", false);
        }
      });
    },

    // Channels
    to_channel: function(user, channel, fact) {
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
    }

  };

  $.fn.factlink = function(method) {
    // Method calling logic
    if (methods[method]) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    }
    else if (typeof method === 'object' || !method) {
      return methods.init.apply(this, arguments);
    }
    else {
      $.error('Method ' + method + ' does not exist on jQuery.factlink');
    }
  };

  // Private functions		
  function data_attr(el, attr, data) {
    $(el).attr("data-" + attr, data);
    $(el).data(attr, data);
  }

  function init_fact(fact, container) {
    var $t = $(fact);
    if (!$t.data("initialized")) {
      $t.find('.edit').editable('/factlink/update_title', {
        indicator : 'Saving...',
        tooltip		: 'You can edit this title to place the fact in the correct context.'
      });

      $t.data("container", container);
      $t.data("wheel", new Wheel(fact));
      $t.data("wheel").init($t.find(".wheel").get(0));

      $t.find("a.add-to-channel").hoverIntent(function(e) {
        channelList = $t.find(".channel-listing");
        $(channelList).css({
          "top": e.pageY  + 10 + "px",
          "left": e.pageX - 30 + "px"
        }).fadeIn("fast");
      }, function() {
        $t.find(".channel-listing").delay(600).fadeOut("fast");
      });

      $t.find(".opinion-box").find("img").tipsy({
        gravity: 's'
      });
      // Now setting a function in the jquery data to keep track of it, would be prettier with custom events
      $t.data("update", function(data) {
        var fact = $t; 
        fact.data("wheel").opinions.each(function() {
          data_attr(this, "value", data[$(this).data("opinions")].percentage);
        });
        fact.find(".authority span").text(data.authority);
        fact.data("wheel").update();
      });

      $t.data("initialized", true);
    }
    return $t;
  }
})(jQuery);
