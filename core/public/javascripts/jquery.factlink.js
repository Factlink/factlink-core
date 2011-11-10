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
    
    function authority(w, authority_element) { 
      var auth = authority_element.data("authority");
      var pos = w.params.dim + (w.params.dim * 0.25);
      if (!authority_element.raphael) {
        return (authority_element.raphael = w.r.text(pos, pos, auth).attr({"font-size" : "13px", "fill" : "#ccc"}));
      } else { 
        return authority_element.raphael.attr({"text": auth});
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
      })
      .each(function() {
        var percentage = $(this).data("value");
        if (percentage < 15) {
          percentage = 15 ;
        } else if (percentage > 40) {
          percentage = percentage - percentage/large_ones*too_much;
        }
        this.display_value = percentage;
      });

    };

    Wheel.prototype.update = function() {
      var wheel = this;
      var a = authority(wheel, wheel.authority);
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
      w.r.customAttributes.arc = function(percentage, percentage_offset, radius) {
      percentage = percentage - 2; // add padding after arc
       var  large_angle = percentage > 50, 
            box_dim = w.params.dim + 6,
            start_angle = percentage_offset * 2 * Math.PI /100,
            end_angle   = (percentage_offset + percentage) * 2 * Math.PI / 100,
            start_x = box_dim +  radius * Math.cos(start_angle),
            start_y = box_dim - radius * Math.sin(start_angle),
            end_x   = box_dim + radius * Math.cos(end_angle),
            end_y   = box_dim - radius * Math.sin(end_angle);
        return {
          path: [
            ['M', start_x, start_y],
            ['A', radius, radius, 0, (large_angle ? 1 : 0), 0, end_x, end_y]
          ]};
      };
      this.update();
      this.bind_events();
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
          console.log('switchTabAction')
          $t.find(".tab_content[rel=" + active + "] .add-evidence").toggle();
          $t.find(".tab_content[rel=" + active + "] .evidence").toggle();
          var action = $t.find(".add-action[rel=" + active + "] > a"); 
          action.text($(action).text() === 'Add facts' ? 'Show facts' : 'Add facts');
        }
        function addEventHandlersDoAdd($t){
          $t.find("a.do-add").live("click", function() {
            $t.find('.evidence-list').hide();
            $t.find('.evidence-search-results').show();
            return false;
          });
        }
        function addEventHandlersReturnFromAdd($t) {
          $t.find("a.return-from-add").bind("click", function() {
            $t.find('.evidence-list').show();
            $t.find('.evidence-search-results').hide();
            return false;
          });
        }
        function addEventHandlersReturnFromEvidenceAdd($t) {
          $t.find("a.close-evidence-add").bind("click", function() {
            $t.find('.page').hide();
            $t.find('.evidence-search-results').show();
            return false;
          });
          
        }
        
        
        function addEventHandlersSubmitButton($t) {
          
          $t.find('button.supporting').bind('click', function() {
            submitEvidence($t, "supporting");
          });
          
          $t.find('button.weakening').bind('click', function() {
            submitEvidence($t, "weakening");
          });
        }
        
        function addEventHandlersTabs($t){          
          $t.find("ul.evidence li").click(function() {
            $t.find(".tab_content, div.add-action").hide(); 
            var activeTab = $(this).find("a").attr("class"); 
            $t.find(".tab_content[rel='" + activeTab + "']").show();
            $t.find("div.add-action[rel='" + activeTab + "']").show();

            if($t.find(".dropdown-container").is(":hidden")) { 
              $t.find(".dropdown-container").slideDown();

              if (!$t.data('loaded-evidence')) {
                getEvidence($t);
                $t.data('loaded-evidence', true);
              }

              $(this).addClass("active");
            } else { 
              if($(this).hasClass("active")) {
                $t.find(".dropdown-container").slideUp(function() {
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
          addEventHandlersReturnFromAdd($t);
          addEventHandlersReturnFromEvidenceAdd($t);
          
          addEventHandlersSubmitButton($t);
          
          $t.data('loaded-evidence', false);
          
          $t.bind("factlink:switchTabAction", function(e, active)  {
            switchTabAction(active); 
          });
          // Evidence buttons
          $t.find(".existing_evidence a").live("ajax:complete", function(et, e){
            $(this).closest('ul').children().find('a').removeClass("active");
            $(this).addClass('active');
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

  function getEvidence($t) {
    var id = $t.attr("data-fact-id");

    $.ajax({
      url: '/facts/' + id + '/fact_relations',
      type: "GET",
      dataType: "script",
      success: function(data) {
      },
      error: function(data) {
      }
    });
  }


  function bindEvidencePrepare($c) {
    $c.find('.results ul li.evidence').live('click', function() {
      showEvidenceAdd($c);

      var elem = $(this);
      var evidenceId = elem.data('evidence-id');
      var evidenceDisplayString = elem.html();
      
      // Set the evidence ID used for posting
      console.log('setting: ' + evidenceId);
      $c.data('evidenceId', evidenceId);

      // Set the displaystring to the evidence bubble
      $c.find('.evidence-add .evidence').html(evidenceDisplayString);
    });
  }
  
  function submitEvidence($c, type) {
    var factId      = $c.attr("data-fact-id");
    var evidenceId  = $c.data("evidence-id");
    
    console.log('evId: ' + evidenceId);
    
    if (type === "supporting") {
      var url_part = "/add_supporting_evidence/";
    } else if (type === "weakening") {
      var url_part = "/add_weakening_evidence/";
    } else {
      alert('There is a problem adding the evidence to this Factlink. We are sorry for the inconvenience, please try again later.');
    }

    // TODO: This should changed to use the FactRelationController
    $.post("/factlink/" + factId + url_part + evidenceId, function(data) {
    });
  }
  
  function bindInstantSearch($c) {
    // Bind the instant search
    var is_timeout;
    $c.find('.search-area .evidence_search').keyup( function() {
      var elem = $(this);
      $('.user-search-input').html(elem.val());

      if (elem.val().length >= 2) {
          clearTimeout(is_timeout);
          is_timeout = setTimeout(function() {
            elem.closest('form').submit();
          }, 200); // <-- choose some sensible value here                                      
      }
    });
  }
  
  function showEvidenceList($c) {
    hidePages($c);
    $c.find('.evidence-list').show();
  }
  function showEvidenceSearchResults($c) {
    hidePages($c);
    $c.find('.evidence-search-results').show();
  }
  function showEvidenceAdd($c) {
    hidePages($c);
    $c.find('.evidence-add').show();
  }
  function hidePages($c) {
    $c.find('.page').hide();
  }
  

  function init_fact(fact, container) {
    var $t = $(fact);
    var $c = $(container);
    if (!$t.data("initialized")) {
      $t.find('.edit').editable('/factlink/update_title', {
        indicator : 'Saving...',
        tooltip		: 'You can edit this title to place the fact in the correct context.'
      });

      $t.data("container", container);
      $t.data("wheel", new Wheel(fact));
      $t.data("wheel").init($t.find(".wheel").get(0));

      bindEvidencePrepare($c);
      bindInstantSearch($c);

      // Channels are in the container
      $c.find("li.add-to-channel")
        .hoverIntent(function(e) {
          var channelList = $t.find(".channel-listing");

          $(channelList).fadeIn("fast");
            
          }, function() {
            $t.find(".channel-listing").delay(600).fadeOut("fast");
          })
        .bind('click', function(e) {
          e.preventDefault();
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
