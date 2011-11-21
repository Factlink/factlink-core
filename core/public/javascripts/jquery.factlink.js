(function($) {
  var Wheel = (function() {
    function Wheel(fact, params) {
      this.fact = fact;
      this.opinions = $(fact).find(".opinion");
      this.authority = $(fact).find(".authority").first();
      this.params = $.extend(params, {
        "dim": 24,
        "radius": 18,
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
        authority_element.raphael = w.r.text(pos, pos, auth).attr({
          "font-size": "13px",
          "fill": "#ccc"
        });
      } else {
        authority_element.raphael.attr({
          "text": auth
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
          $fact.find(".tab_content[rel=" + active + "] .add-evidence").toggle();
          $fact.find(".tab_content[rel=" + active + "] .evidence").toggle();
          var action = $fact.find(".add-action[rel=" + active + "] > a");
          action.text($(action).text() === 'Add facts' ? 'Show facts' : 'Add facts');
        }

        function addEventHandlersDoAdd($fact) {
          $fact.find("a.do-add").live("click", function() {
            $fact.find('.evidence-list').hide();
            $fact.find('.evidence-search-results').show();
            return false;
          });
        }

        function addEventHandlersReturnFromAdd($fact) {
          $fact.find("a.return-from-add").bind("click", function() {
            $fact.find('.evidence-list').show();
            $fact.find('.evidence-search-results').hide();
            
            resetSearch($fact);
            return false;
          });
        }

        function addEventHandlersReturnFromEvidenceAdd($fact) {
          $fact.find("a.close-evidence-add").bind("click", function() {
            $fact.find('.page').hide();
            $fact.find('.evidence-search-results').show();
            return false;
          });
        }

        function addEventHandlersSubmitButton($fact) {
          $fact.find('button.supporting').bind('click', function() {
            submitEvidence($fact, "supporting");
          });

          $fact.find('button.weakening').bind('click', function() {
            submitEvidence($fact, "weakening");
          });
        }

        function addEventHandlersTabs($fact) {
          $fact.find("ul.evidence li").click(function() {

            if ($fact.find(".dropdown-container").is(":hidden")) {
              $fact.find(".dropdown-container").slideDown();

              // AJAX call to load the FactRelations
              if (!$fact.data('loaded-evidence')) {
                getEvidence($fact);
                $fact.data('loaded-evidence', true);
              }

              $(this).addClass("active");

            } else {
              if ($(this).hasClass("active")) {
                $fact.find(".dropdown-container").slideUp(function() {
                  $fact.find("ul.evidence li").removeClass("active");
                });
              } else {
                $fact.find("ul.evidence li").removeClass("active");
                $(this).addClass("active");
              }
            }
            return false;
          });
        }

        function initialize($fact) { /* based on http://www.sohtanaka.com/web-design/simple-tabs-w-css-jquery/ */
          //On Click Event
          addEventHandlersTabs($fact);
          addEventHandlersDoAdd($fact);
          addEventHandlersReturnFromAdd($fact);
          addEventHandlersReturnFromEvidenceAdd($fact);

          addEventHandlersSubmitButton($fact);

          $fact.data('loaded-evidence', false);

          $fact.bind("factlink:switchTabAction", function(e, active) {
            switchTabAction(active);
          });
          // Evidence buttons
          $fact.find(".existing_evidence a").live("ajax:complete", function(et, e) {
            $(this).closest('ul').children().find('a').removeClass("active");
            $(this).addClass('active');
          });
          $fact.data("initialized", true);
        } /*start of method*/
        var $fact = $(this);
        $fact.data("facts", {});
        if (!$fact.data("initialized")) {
          initialize($fact);
        }
        $fact.find("article.fact").each(function() {
          var fact = init_fact(this, $fact);
          $fact.data("facts")[fact.attr("data-fact-id")] = fact;
        });

        // Prevents boxes from dissapearing on mouse over
        $fact.find(".float-box").mouseover(function() {
          stop_fade($(this));
        });
        $fact.find(".float-box").mouseout(function() {
          if (!$(this).find("input#channel_title").is(":focus")) {
            $(this).delay(500).fadeOut("fast");
          }
        });
      });
    },
    
    update: function(data) {
      var $fact = $(this).data("container") || $(this);
      if ($fact.data("initialized")) {
        $(data).each(function() {
          var fact = $fact.data("facts")[this.id];
          if (fact && $(fact).data("initialized")) {
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
          if (!$(current_op).data("user-opinion")) {
            $.post("/facts/" + $(fact).data("fact-id") + "/opinion/" + opinion.data("opinion"), function(data) {
              data_attr(current_op, "user-opinion", true);
              fact.factlink("update", data);
            });
          }
          else {
            $.ajax({
              type: "DELETE",
              url: "/facts/" + $(fact).data("fact-id") + "/opinion/",
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

  function getEvidence($fact) {
    var id = $fact.attr("data-fact-id");
    var loader = $fact.find('.loading-evidence');
    $.ajax({
      url: '/facts/' + id + '/fact_relations',
      type: "GET",
      dataType: "script",
      success: function(data) {
        loader.hide();
      },
      error: function(data) {}
    });
  }


  function bindEvidencePrepare($c) {
    $c.find('.results ul li.evidence').live('click', function() {
      showEvidenceAdd($c);

      var elem = $(this);
      var evidenceId = elem.data('evidence-id');
      var evidenceDisplayString = elem.html();

      // Set the evidence ID used for posting
      $c.data('evidenceId', evidenceId);

      // Set the displaystring to the evidence bubble
      $c.find('.evidence-add .evidence').html(evidenceDisplayString);
    });
  }

  function submitEvidence($c, type) {
    var factId = $c.attr("data-fact-id");
    var evidenceId = $c.data("evidence-id");
    var url_part;

    if (type === "supporting") {
      url_part = "/add_supporting_evidence/";
    } else if (type === "weakening") {
      url_part = "/add_weakening_evidence/";
    } else {
      alert('There is a problem adding the evidence to this Factlink. We are sorry for the inconvenience, please try again later.');
    }

    // TODO: This should changed to use the FactRelationController
    $.ajax({
      url: "/factlink/" + factId + url_part + evidenceId,
      type: "post",
      dataType: "script",
      success: function() {
        resetSearch($c);
      },
      error: function() {
        console.log('Adding evidence failed: ' + "/factlink/" + factId + url_part + evidenceId);
      }
    });
  }

  function bindInstantSearch($c) {
    var is_timeout;
    $c.find('.search-area .evidence_search').keyup(function() {
      showSearchResults($c);
      
      var elem = $(this);
      $('.user-search-input').html(elem.val());

      if (elem.val().length >= 2) {
        clearTimeout(is_timeout);
        is_timeout = setTimeout(function() {
          elem.closest('form').submit();
        }, 200); // <-- choose some sensible value here        
      } else {
        hideSearchResults($c);
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
  
  function resetSearch($c) {
    hideSearchResults($c);
    $c.find('.search-area .evidence_search').val('');
    
  }
  function showSearchResults($c) {
    $c.find('.evidence-search-results .search-term-results').show();
    $c.find('.evidence-search-results .default-results').hide();
  }
  function hideSearchResults($c) {
    $c.find('.evidence-search-results .search-term-results').hide();
    $c.find('.evidence-search-results .default-results').show();
  }
  function getChannelChecklist(fact) {
    var id = fact.attr("data-fact-id");
    $.ajax({
      url: '/facts/' + id + '/channels',
      type: "GET",
      dataType: "HTML",
      success: function(data) {fact.find(".channel-listing").html(data);},
      error: function(data) {}
    });    
  }

  function init_fact(fact, container) {
    var $fact = $(fact);
    var $c = $(container);
    if (!$fact.data("initialized")) {
      $fact.find('.edit').editable('/facts/update_title', {
        indicator: 'Saving...',
        tooltip: 'You can edit this title to place the Factlink in the correct context.'
      });

      $fact.data("container", container);
      $fact.data("wheel", new Wheel(fact));
      $fact.data("wheel").init($fact.find(".wheel").get(0));

      bindEvidencePrepare($c);
      bindInstantSearch($c);

      // Channels are in the container
      $fact.find(".add-to-channel")
        .hover(function(){getChannelChecklist($fact);})
        .hoverIntent(function(e) {
          var channelList = $fact.find(".channel-listing");
          $(channelList).fadeIn("fast");
      }, function() {
        $fact.find(".channel-listing").delay(600).fadeOut("fast");
      }).bind('click', function(e) {
        e.preventDefault();
      });

      $fact.find(".opinion-box").find("img").tipsy({
        gravity: 's'
      });
      // Now setting a function in the jquery data to keep track of it, would be prettier with custom events
      $fact.data("update", function(data) {
        $fact.data("wheel").opinions.each(function() {
          data_attr(this, "value", data[$(this).data("opinions")].percentage);
        });
        data_attr($fact.data("wheel").authority,"authority",data.authority);
        $fact.data("wheel").update();
      });

      $fact.data("initialized", true);
    }
    return $fact;
  }
})(jQuery);
