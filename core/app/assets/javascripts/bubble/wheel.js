var Wheel = (function() {
  function Wheel(fact, params) {
    this.fact = fact;
    this.opinions = $(fact).find(".opinion");
    this.authority = $(fact).find(".authority").first();
    this.params = $.extend(params, {
      "dim": 24,
      "radius": 16,
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
    var the_arc = [op.display_value, p.offset, p.r];

    if (!op.raphael) {
      // set new path
      return (op.raphael = w.r.path().attr({
        arc: the_arc,
        stroke: $(op).data("color"),
        "stroke-width": w.params.default_stroke.stroke,
        opacity: opacity
      }));
    } else {
      return op.raphael.animate({
        arc: the_arc,
        opacity: opacity
      }, 200, '<>');
    }
  }

  function update_authority(w, authority_element) {
    var auth = authority_element.data("authority");
    var pos = w.params.dim + (w.params.dim * 0.25);
    
    if (!authority_element.raphael) {
      authority_element.raphael = w.r.text(pos, pos+4, auth).attr({
        "font-size": "13pt",
        "fill": "#999"
      });
    } else {
      authority_element.raphael.attr({
        "text": auth,
        "x": pos,
        "y": pos
      });
    }
  }

  Wheel.prototype.calc_display = function(opinions) {
    var too_much = 0;
    var large_ones = 0;
    $(opinions).each(function() {
      var percentage = $(this).data("value");
      if (percentage < 15) {
        too_much += 15 - percentage;
      } else if (percentage > 40) {
        large_ones += percentage;
      }
    }).each(function() {
      var percentage = $(this).data("value");
      if (percentage < 15) {
        percentage = 15;
      } else if (percentage > 40) {
        percentage = percentage - percentage / large_ones * too_much;
      }
      this.display_value = percentage;
    });

  };

  Wheel.prototype.update = function() {
    var wheel = this;
    update_authority(wheel, wheel.authority);
    wheel.calc_display(this.opinions);
    var offset = 0;
    $(this.opinions).each(function() {
      var z = arc(wheel, this, {
        offset: offset,
        val: this.display_value,
        r: wheel.params.radius
      });
      offset = offset + this.display_value;
    });
  };

  Wheel.prototype.bind_events = function() {
    var w = this;
    $(this.opinions).each(function() {
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
      // Bootstap popver
      $(this.raphael.node).attr("rel", "twipsy").twipsy({
        title: function() { return $t.data("name") + ": " + $t.data("value") + "%"; }, 
        offset: 0,
        placement:"left" 
      });
    });
  };

  Wheel.prototype.init = function(canvas) {
    var w = this;
    w.r = Raphael(canvas, w.params.dim * 2 + 17, w.params.dim * 2 + 17);
    w.r.customAttributes.arc = function(percentage, percentage_offset, radius) {
      percentage = percentage - 2; // add padding after arc
      var large_angle = percentage > 50,
          box_dim = w.params.dim + 6,
          start_angle = percentage_offset * 2 * Math.PI / 100,
          end_angle = (percentage_offset + percentage) * 2 * Math.PI / 100,
          start_x = box_dim + radius * Math.cos(start_angle),
          start_y = box_dim - radius * Math.sin(start_angle),
          end_x = box_dim + radius * Math.cos(end_angle),
          end_y = box_dim - radius * Math.sin(end_angle);
      return {
        path: [
          ['M', start_x, start_y],
          ['A', radius, radius, 0, (large_angle ? 1 : 0), 0, end_x, end_y]
        ]
      };
    };
    this.update();
    this.bind_events();
  };
  return Wheel;
})();

